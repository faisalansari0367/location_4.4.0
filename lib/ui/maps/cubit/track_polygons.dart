// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
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
    if (Get.currentRoute != '/MapsPage' || (Get.isDialogOpen ?? true)) return;

    _userIsInside(polygonsInCoverage, currentPosition);
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
          log('form is empty : ${entry?.form.isEmpty}');
          log('should show pop up : ${entry?.form.isEmpty}');
          if (entry != null) {
            // final difference = DateTime.now().difference(entry.enterDate!).inMinutes;
            if (entry.form.isNotEmpty) {
              return;
            }
          }
        }
        print('calling hide pop up timer function');
        dontShowAgain.call(() {
          showPopup(currentPosition);
        });
      },
    );

    /// this will take care of updating and callin`g the notify manager after a certain duration
    // notifyManager.updateData(currentPosition, currentPolygon);
  }

  int getDifference(DateTime? date) {
    if (date == null) return 0;
    final difference = DateTime.now().difference(date);
    return difference.inMinutes;
  }

  void showPopup(LatLng position) async {
    if (currentPolygon == null) {
      return;
    }
    if (attemptOfShowingPopUp >= 3) return;
    if (attemptOfShowingPopUp == 2) {
      notifyManager.updateData(position, currentPolygon);
    }
    attemptOfShowingPopUp++;

    await DialogService.showDialog(
      child: EnterProperty(
        stream: polygonsInCoverage.stream,
        // onTap: (s) => Get.to(() => EntryForm(polygonModel: s)),
        onTap: (s) {
          _stopTimers();

          Get.to(() => GlobalQuestionnaireForm(
                zoneId: s.id!,
              ));
        },
        onNO: () {},
      ),
    );
    hidePopUp();
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
      this.polygonsInCoverage.add({currentPolygon!});
      logbookEntryHandler.update(true, currentPolygon!);
    } else {
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
    // hidePopUpTimer.cancel();
    // notifyManager.cancel();
    dontShowAgain.cancel();
    hidePopUpTimer.cancel();
    // logbookEntryHandler.cancel();
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
