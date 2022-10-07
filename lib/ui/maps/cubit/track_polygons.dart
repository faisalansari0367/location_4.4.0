// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

import '../../../widgets/dialogs/dialog_service.dart';
import '../location_service/map_toolkit_utils.dart';
import '../models/polygon_model.dart';
import '../view/widgets/dialog/enter_property.dart';
import '../view/widgets/dialog/notify_manager.dart';
import '../view/widgets/entry_form/entry_form.dart';

class TrackPolygons {
  final MapsRepo mapsRepo;
  final Api api;
  final String pic;

  final polygonsInCoverage = BehaviorSubject<Set<PolygonModel>>.seeded({});
  PolygonModel? currentPolygon;
  bool isManagerNotified = false;
  bool userHasEntered = false;
  bool isUserInProperty = false;
  bool hasLogbookEntry = false;

  TrackPolygons({required this.mapsRepo, required this.pic, required this.api}) {
    logbookEntryHandler = LogbookEntryHandler(
      pic: pic,
      // polygonsInCoverage: polygonsInCoverage,
      mapsRepo: mapsRepo,
      api: api,
    );
  }

  // final logbookStatus = {
  //   'userHasEntered': false,
  //   'hasLogbookEntry': false,
  //   'userHasExited': false,
  // };

  /// Timers
  // [hide pop up after 1 minute]
  final CallRestricter hidePopUpTimer = CallRestricter(duration: 1.minutes, callback: hidePopUp);
  final notifyManager = MapsCallbackDebouncer(duration: 5.minutes);
  // final lobookEntryDebouncer = MapsCallbackDebouncer(duration: 10.seconds);

  final CallRestricter dontShowAgain = CallRestricter(duration: 15.minutes, callback: () {});
  late LogbookEntryHandler logbookEntryHandler;

  static void hidePopUp() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  //
  void update(Set<PolygonModel> polygonsInCoverage, LatLng currentPosition) {
    _userIsInCoverage(polygonsInCoverage, currentPosition);
    this.polygonsInCoverage.add(polygonsInCoverage);

    // show popup if polygons are in coverage

    // page is maps page
    // dialog is not showing
    if (Get.currentRoute != '/MapsPage' || (Get.isDialogOpen ?? true)) return;

    // showPopup();
    hidePopUpTimer.call(() {
      dontShowAgain.call(showPopup);
    });

    // notify Manager
    notifyManager.call(() {
      _notifyManager(currentPosition);
    });

    // logbook entry
    // log('logbookStatus: $userHasEntered, ${logbookStatus['userHasEntered']}');
  }

  void showPopup() async {
    // hidePopUpTimer.call(hidePopUp);
    await DialogService.showDialog(
      child: EnterProperty(
        stream: polygonsInCoverage.stream,
        onTap: (s) {
          // result = true;
          // _notifyManagerTimer?.cancel();
          // _notifyManagerTimer = null;
          // cubit.stopLocationUpdates();

          Get.to(
            () => EntryForm(polygonModel: s),
          );
          // Get.back();
        },
        onNO: () {
          // result = false;
          // disabledPolygons.addAll(currentPolygons);
          // _notifyManagerTimer?.cancel();
          // _notifyManagerTimer = null;
        },
      ),
    );
  }

  void _userIsInCoverage(Set<PolygonModel> polygons, LatLng currentPosition) async {
    final userIsInside = polygons.where(
      (element) => MapsToolkitService.isInsidePolygon(
        latLng: currentPosition,
        polygon: element.points,
      ),
    );

    if (userIsInside.isNotEmpty) {
      // if (userHasEntered) return;
      currentPolygon = userIsInside.first;
      // userHasEntered = true;
      logbookEntryHandler.update(true, currentPolygon!);
      // _logbookEntry(currentPosition);
    } else {
      // if (!userHasEntered) return;
      // userHasEntered = false;
      // _logbookEntry(currentPosition);
      logbookEntryHandler.update(false, currentPolygon!);
      await 100.milliseconds.delay();
      currentPolygon = null;
      // _logbookEntry(currentPosition);
    }

    // user already entered and exiting now

    // if (userHasEntered && userIsInside.isEmpty) {
    //   _logbookEntry(currentPosition, true);
    //   log('user exiting from the zone now');
    //   userHasEntered = false;
    //   return;
    // }

    // user already entered and still inside
    // if (userHasEntered && userIsInside.isNotEmpty) {
    //   if (isUserInProperty) return;
    //   // _logbookEntry(currentPosition, false);
    //   log('user still inside the zone');
    //   isUserInProperty = true;
    //   return;
    // } else

    // user is entering now
    // if (!userHasEntered && userIsInside.isNotEmpty) {
    //   userHasEntered = true;
    //   _logbookEntry(currentPosition, false);
    //   log('user entering the zone now');
    //   return;
    // }

    // if (userIsInside.isNotEmpty) {
    //   currentPolygon = userIsInside.first;
    //   userHasEntered = true;
    //   // _logbookEntry(currentPosition);
    // } else {
    //   userHasEntered = false;
    //   currentPolygon = null;
    //   // _logbookEntry(currentPosition);
    // }

    // // check if user has exited
    // if (userHasEntered && currentPolygon != null) {
    //   final userHasExited = MapsToolkitService.isInsidePolygon(
    //     latLng: currentPosition,
    //     polygon: currentPolygon!.points,
    //   );
    //   if (!userHasExited) {
    //     userHasEntered = false;
    //     currentPolygon = null;
    //     // _logbookEntry(currentPosition);
    //   }
    // }

    // if (userIsInside.isNotEmpty == userHasEntered) {}
  }

  // notifyManager
  void _notifyManager(LatLng position) async {
    if (isManagerNotified) return;
    if (currentPolygon == null) return;
    final result = await mapsRepo.notifyManager(
      pic,
      position.latitude.toString(),
      position.longitude.toString(),
      currentPolygon!.id!,
    );
    result.when(
      success: (s) {
        isManagerNotified = true;
        // final name = '${currentPolygon?.createdBy?.firstName} ${currentPolygon?.createdBy?.lastName}';
        if (Get.currentRoute != '/MapsPage') return;
        // final manager = name.isEmpty ? 'Property Manager' : name;
        DialogService.showDialog(
          child: NotifyManagerDialog(
            message: s,
          ),
        );
      },
      failure: (e) => DialogService.failure(error: e),
    );
  }

  // void _logbookEntry(LatLng currentPosition, [bool isExiting = false]) async {
  //   if (currentPolygon == null) return;
  //   final result = await api.logBookEntry(
  //     pic,
  //     currentPolygon!.id!,
  //     isExiting: isExiting,
  //   );
  //   result.when(
  //     success: (s) {
  //       hasLogbookEntry = true;
  //       // logbookStatus['userHasEntered'] = userHasEntered;
  //     },
  //     failure: (e) => {
  //       log(NetworkExceptions.getErrorMessage(e)),
  //     },
  //   );
  // }

  // show popup

  // logbook entry
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

class MapsCallbackDebouncer {
  MapsCallbackDebouncer({required this.duration});

  final Duration duration;
  // final VoidCallback callback;
  Timer? _timer;

  void call(VoidCallback callback) {
    // if (duration == Duration.zero) {
    //   callback();
    // } else {
    //   // _timer?.cancel();
    //   // _timer = Timer(duration, callback);
    // }
    if (!(_timer?.isActive ?? false)) {
      // onCall();
      _timer = Timer(duration, callback);
    }
  }
}

class LogbookEntryHandler {
  String pic;
  PolygonModel? polygonModel;
  bool? isExiting;
  MapsRepo mapsRepo;
  Api api;

  static bool _isInside = false;

  LogbookEntryHandler({
    required this.pic,
    required this.api,
    this.polygonModel,
    // this.isExiting,
    required this.mapsRepo,
  });

  static void setIsInside(bool isInside) {
    final hasChange = _isInside != isInside;
    if (!hasChange) return;
    print('user Is Inside $_isInside');
  }

  void _markExit() async {
    final result = await api.markExit(polygonModel!.id!);
    result.when(
      success: (s) {
        log('logbook exit date updated');
      },
      failure: (e) => {
        log(NetworkExceptions.getErrorMessage(e)),
      },
    );
  }

  void _logbookEntry([bool isExiting = false]) async {
    if (polygonModel == null) return;
    if (isExiting) return _markExit();

    final result = await api.logBookEntry(
      pic,
      polygonModel!.id!,
      isExiting: isExiting,
    );
    result.when(
      success: (s) {
        log('logbook entry success');
      },
      failure: (e) => {
        log(NetworkExceptions.getErrorMessage(e)),
      },
    );
  }

  Future<void> update(bool isInside, PolygonModel polygonModel) async {
    // log('logbook entry is ');
    // if (isInside == isExiting) {
    //   isExiting = isInside;

    //   return;
    // }
    if (this.isExiting == isInside) return;
    this.isExiting = isInside;
    this.polygonModel = polygonModel;
    log('user is exiting ${!isInside}');
    _logbookEntry(!isInside);
    // final result = await mapsRepo.logBookEntry(
    //   pic,
    //   null,
    //   polygonModel.id!,
    //   isExiting: isExiting,
    // );
    // result.when(
    //   success: (s) {},
    //   failure: (e) => {
    //     log(NetworkExceptions.getErrorMessage(e)),
    //   },
    // );
  }
}
