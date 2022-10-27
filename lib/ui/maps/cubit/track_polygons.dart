// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:ui';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/forms/view/global_questionnaire_form.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../../../widgets/dialogs/dialog_service.dart';
import '../location_service/map_toolkit_utils.dart';
import '../models/polygon_model.dart';
import '../view/widgets/dialog/enter_property.dart';
import 'logbook_entry_handler.dart';
import 'notify_manager_handler.dart';

/// 1. hide pop up after 30 seconds
/// if user did not fill out the form in 30 seconds, the pop up will be hidden
/// 2. IF still in geofences after a further 60 seconds – present entry popup option again
/// iF they have remained  in the same geofence and still not registered after a further 180 seconds
/// if still not filled out the form, notify manager and update the logbook entry
///
///
///

class TrackPolygons {
  final MapsRepo mapsRepo;
  final Api api;

  final polygonsInCoverage = BehaviorSubject<Set<PolygonModel>>.seeded({});
  PolygonModel? currentPolygon;
  bool isManagerNotified = false;
  final CallRestricter hidePopUpTimer = CallRestricter(duration: 30.seconds, callback: hidePopUp);
  NotifyManagerHandler notifyManager = NotifyManagerHandler();
  final CallRestricter dontShowAgain = CallRestricter(duration: 180.seconds, callback: () {});
  late LogbookEntryHandler logbookEntryHandler;
  int attemptOfShowingPopUp = 0;

  TrackPolygons({required this.mapsRepo, required this.api}) {
    // notifyManager ??= NotifyManagerHandler(mapsRepo, duration: 5.minutes);
    notifyManager.init(mapsRepo);
    logbookEntryHandler = LogbookEntryHandler(
      mapsRepo: mapsRepo,
      api: api,
    );
  }

  /// Timers
  // [hide pop up after 1 minute]

  static void hidePopUp() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  //
  void update(Set<PolygonModel> polygonsInCoverage, LatLng currentPosition) {
    _userIsInside(polygonsInCoverage, currentPosition);
    this.polygonsInCoverage.add(polygonsInCoverage);

    // show popup if polygons are in coverage

    // page is maps page
    // dialog is not showing
    if (Get.currentRoute != '/MapsPage' || (Get.isDialogOpen ?? true)) return;

    // showPopup();

    hidePopUpTimer.call(
      () {
        if (currentPolygon?.id != null) {
          final entry = api.getLogRecord(currentPolygon!.id!);
          if (entry != null) {
            final difference = DateTime.now().difference(entry.enterDate!).inMinutes;
            print('$difference is the difference');
            if (entry.form.isNotEmpty) {
              return;
            }
          }
        }
        dontShowAgain.call(() => showPopup(currentPosition));
      },
    );

    /// this will take care of updating and calling the notify manager after a certain duration
    // notifyManager.updateData(currentPosition, currentPolygon);
  }

  int getDifference(DateTime? date) {
    if (date == null) return 0;
    final difference = DateTime.now().difference(date);
    return difference.inMinutes;
  }

  void showPopup(LatLng position) async {
    if (attemptOfShowingPopUp >= 3) return;
    if (attemptOfShowingPopUp == 2) {
      notifyManager.updateData(position, currentPolygon);
    }

    attemptOfShowingPopUp++;
    // if (currentPolygon?.id != null) {
    // final entry = api.getLogRecord(currentPolygon!.id!);
    // if (entry?.enterDate != null) {
    //   final difference = DateTime.now().difference(entry!.enterDate!).inMinutes;
    //   print('$difference is the difference');
    //   if (difference < 15) {
    //     return;
    //   }
    //   if (getDifference(entry.exitDate) > 30) {}
    // }
    // }
    await DialogService.showDialog(
      child: EnterProperty(
        stream: polygonsInCoverage.stream,
        // onTap: (s) => Get.to(() => EntryForm(polygonModel: s)),
        onTap: (s) {
          _stopTimers();
          hidePopUp();
          Get.to(() => GlobalQuestionnaireForm(polygonModel: s));
        },
        onNO: () {},
      ),
    );
  }

  void _userIsInside(Set<PolygonModel> polygons, LatLng currentPosition) async {
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
      logbookEntryHandler.update(true, currentPolygon!);
    } else {
      if (currentPolygon == null) return;
      attemptOfShowingPopUp = 0;

      logbookEntryHandler.update(false, currentPolygon!);
      // currentPolygon = null;
    }
  }

  void dispose() {
    _stopTimers();
  }

  void _stopTimers() {
    hidePopUpTimer.cancel();
    notifyManager.cancel();
    dontShowAgain.cancel();
    hidePopUpTimer.cancel();
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
      onCall();
      _timer = Timer(duration, callback);
    }
  }

  void cancel() => _timer?.cancel();
}
