// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/forms/forms_page.dart';
import 'package:bioplus/ui/maps/cubit/logbook_entry_handler.dart';
import 'package:bioplus/ui/maps/cubit/notify_manager_handler.dart';
import 'package:bioplus/ui/maps/location_service/map_toolkit_utils.dart';
import 'package:bioplus/ui/maps/view/widgets/dialog/enter_property.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

/// 1. hide pop up after 30 seconds
/// if user did not fill out the form in 30 seconds, the pop up will be hidden
/// 2. IF still in geofences after a further 60 seconds – present entry popup option again
/// iF they have remained  in the same geofence and still not registered after a further 180 seconds
/// if still not filled out the form, notify manager and update the logbook entry
///
///
///

class TrackPolygons {
  final GeofencesRepo geofenceRepo;
  final Api api;

  final polygonsInCoverage = BehaviorSubject<Set<PolygonModel>>.seeded({});
  PolygonModel? currentPolygon;
  bool isManagerNotified = false;
  static bool isShowingPopUp = false;

  final CallRestricter hidePopUpTimer = CallRestricter(duration: 60.seconds, callback: hidePopUp);
  NotifyManagerHandler notifyManager = NotifyManagerHandler();
  final CallRestricter dontShowAgain = CallRestricter(duration: 240.seconds, callback: () {});
  late LogbookEntryHandler logbookEntryHandler;
  int attemptOfShowingPopUp = 0;

  TrackPolygons({required this.geofenceRepo, required this.api}) {
    isShowingPopUp = false;
    notifyManager.init(geofenceRepo);
    logbookEntryHandler = LogbookEntryHandler(
      geofenceRepo: geofenceRepo,
      api: api,
    );
  }

  /// Timers
  // [hide pop up after 1 minute]

  static void hidePopUp() {
    if (Get.isDialogOpen ?? false) {
      if (isShowingPopUp) {
        Get.back();
        isShowingPopUp = false;
      }
    }
  }

  //p
  static const String _formsPage = '/FormsPage';
  static const String _signaturePage = '/CreateSignature';
  // static const String _mapsPage = '/MapsPage';
  bool get isDialogOpen => Get.isDialogOpen ?? false;
  bool get isFormsPage => Get.currentRoute == _signaturePage;
  bool get isSignaturePage => Get.currentRoute == _formsPage;

  /// this will be called when the user is inside a polygon
  void update(Set<PolygonModel> polygonsInCoverage, LatLng currentPosition) {
    // log('message from track polygons ${polygonsInCoverage.length}}');
    // log('current polygon is ${currentPolygon?.id}');
    // if (isFormsPage || isSignaturePage) return;
    // log('Polygons in coverage ${polygonsInCoverage.length}');
    // (polygonsInCoverage.length)
    _userIsInside(polygonsInCoverage, currentPosition);
    if (isFormsPage || isDialogOpen || isSignaturePage) return;

    // this.polygonsInCoverage.add(polygonsInCoverage);

    // show popup if polygons are in coverage

    // page is maps page
    // dialog is not showing

    // showPopup();

    hidePopUpTimer.call(
      () async {
        if (currentPolygon?.id != null) {
          final entry = await api.getLogRecord(currentPolygon!.id!);
          log('logRecord id is : ${entry?.id}');
          log('form is empty : ${entry?.form?.isEmpty}');
          log('should show pop up : ${entry?.form?.isEmpty}');
          if (entry != null) {
            // final difference = DateTime.now().difference(entry.enterDate!).inMinutes;
            if (entry.form?.isNotEmpty ?? false) {
              return;
            }
          }
        }
        print('calling hide pop up timer function');
        dontShowAgain.call(() => showPopup(currentPosition));
      },
    );

    /// this will take care of updating and callin`g the notify manager after a certain duration
    // notifyManager.updateData(currentPosition, currentPolygon);
  }

  // int getDifference(DateTime? date) {
  //   if (date == null) return 0;
  //   final difference = DateTime.now().difference(date);
  //   return difference.inMinutes;
  // }

  Future<void> showPopup(LatLng position) async {
    if (currentPolygon == null) return;
    if (attemptOfShowingPopUp >= 3) return;
    if (attemptOfShowingPopUp == 2) {
      notifyManager.updateData(position, currentPolygon);
    }
    attemptOfShowingPopUp++;
    isShowingPopUp = true;
    await DialogService.showDialog(
      child: EnterProperty(
        stream: polygonsInCoverage.stream,
        onTap: (s) async {
          _stopTimers();

          final logRecord = await api.getLogRecord(s.id!);
          Get.to(
            () => FormsPage(
              zoneId: s.id!,
              logRecord: logRecord,
              polygon: currentPolygon,
            ),
          );
        },
        onNO: () {},
      ),
    );
    hidePopUp();
  }

  Future<void> _userIsInside(Set<PolygonModel> polygons, LatLng currentPosition) async {
    final userIsInside = polygons.where(
      (element) => MapsToolkitService.isInsidePolygon(
        latLng: currentPosition,
        polygon: element.points,
      ),
    );

    if (userIsInside.isNotEmpty) {
      if (userIsInside.first.id != currentPolygon?.id) {
        hidePopUpTimer.cancel();
        dontShowAgain.cancel();
        attemptOfShowingPopUp = 0;
      }
      currentPolygon = userIsInside.first;
      polygonsInCoverage.add({currentPolygon!});
      logbookEntryHandler.update(true, currentPolygon!);
    } else {
      api.previousZoneExitDateChecker();
      if (currentPolygon == null) return;
      // attemptOfShowingPopUp = 0;
      hidePopUpTimer.cancel();
      dontShowAgain.cancel();
      attemptOfShowingPopUp = 0;

      logbookEntryHandler.update(false, currentPolygon!);
      currentPolygon = null;
    }
  }

  void dispose() {
    _stopTimers();
  }

  void _stopTimers() {
    attemptOfShowingPopUp = 0;
    hidePopUpTimer.cancel();
    dontShowAgain.cancel();
    notifyManager.cancel();
    logbookEntryHandler.cancel();
  }
}

class CallRestricter {
  CallRestricter({required this.duration, required this.callback});
  final VoidCallback callback;

  final Duration duration;
  Timer? _timer;

  void call(VoidCallback onCall) {
    if (!(_timer?.isActive ?? false)) {
      onCall.call();
      _timer = Timer(duration, callback);
    }
  }

  void cancel() => _timer?.cancel();
}
