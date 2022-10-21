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

class TrackPolygons {
  final MapsRepo mapsRepo;
  final Api api;

  final polygonsInCoverage = BehaviorSubject<Set<PolygonModel>>.seeded({});
  PolygonModel? currentPolygon;
  bool isManagerNotified = false;
  final CallRestricter hidePopUpTimer = CallRestricter(duration: 1.minutes, callback: hidePopUp);
  late NotifyManagerHandler notifyManager;
  final CallRestricter dontShowAgain = CallRestricter(duration: 15.minutes, callback: () {});
  late LogbookEntryHandler logbookEntryHandler;

  TrackPolygons({required this.mapsRepo, required this.api}) {
    notifyManager = NotifyManagerHandler(mapsRepo, duration: 5.minutes);
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

    hidePopUpTimer.call(() {
      if (currentPolygon?.id != null) {
        final entry = api.getLogRecord(currentPolygon!.id!);
        if ((entry?.form.isNotEmpty ?? false)) {
          return;
        }
      }
      dontShowAgain.call(showPopup);
    });

    /// this will take care of updating and calling the notify manager after a certain duration
    notifyManager.updateData(currentPosition, currentPolygon);
  }

  void showPopup() async {
    if (currentPolygon?.id != null) {
      final entry = api.getLogRecord(currentPolygon!.id!);
      if (entry?.enterDate != null) {
        return;
      }
    }
    await DialogService.showDialog(
      child: EnterProperty(
        stream: polygonsInCoverage.stream,
        // onTap: (s) => Get.to(() => EntryForm(polygonModel: s)),
        onTap: (s) {
          stopTimers();
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
      // don't show pop up if the zone is the same
      if (userIsInside.first.id != currentPolygon?.id) {
        print('user has already entered in a different zone');
        hidePopUpTimer.cancel();
        dontShowAgain.cancel();
      }
      currentPolygon = userIsInside.first;

      logbookEntryHandler.update(true, currentPolygon!);
    } else {
      if (currentPolygon == null) return;

      logbookEntryHandler.update(false, currentPolygon!);
      await 100.milliseconds.delay();
      // currentPolygon = null;
    }
  }

  void isLoggedInToCurrentZone() {
    if (currentPolygon == null) return;
    api.logbookRecordsStream.listen((event) {
      final data = event.where((element) => element.geofence!.id == currentPolygon!.id).toList();
      if (data.isEmpty) return;
      final first = data.first;
      print(first);
    });
  }

  void stopTimers() {
    hidePopUpTimer.cancel();
    notifyManager.cancel();
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

  void cancel() {
    _timer?.cancel();
  }
}
