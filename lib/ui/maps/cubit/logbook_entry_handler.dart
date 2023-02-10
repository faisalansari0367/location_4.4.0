// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:api_repo/api_repo.dart';
import 'package:get/get.dart';

class LogbookEntryHandler {
  PolygonModel? polygonModel;
  bool? isExiting;
  GeofencesRepo geofenceRepo;
  Api api;

  // final _debouncer = Debouncer(delay: 100.seconds);
  MarkExitHandler? markExitHandler;

  LogbookEntryHandler({
    required this.api,
    this.polygonModel,
    required this.geofenceRepo,
  }) {
    markExitHandler = MarkExitHandler(
      api: api,
      model: polygonModel,
    );
  }

  void cancel() {
    // markExitHandler?.cancel();
    isExiting = null;
  }

  Future<void> _logbookEntry([bool isExiting = false]) async {
    // log('isExiting $isExiting \n polygonModel ${polygonModel?.toJson()}');
    if (polygonModel == null) return;
    if (isExiting) {
      // markExitHandler?.callExit(polygonModel, isExiting);
      return;
    } else {
      // if current polygon is the same as the previous polygon
      final sameZone = markExitHandler?.model?.id == polygonModel?.id;
      // if user is still in the same zone
      // cancel the timer
      if (sameZone) {
        markExitHandler?.cancel();
      }
    }
    // log('pic is ${polygonModel!.pic}');
    final result = await api.logBookEntry(polygonModel!.id!, isExiting: isExiting);
    result.when(
      success: (s) {
        log('logbook entry success');
      },
      failure: (e) => log(NetworkExceptions.getErrorMessage(e)),
    );
  }

  Future<void> update(bool isInside, PolygonModel polygonModel) async {
    if (isExiting == isInside && this.polygonModel == polygonModel) return;
    isExiting = isInside;
    this.polygonModel = polygonModel;
    log('user is exiting ${!isInside}');
    _logbookEntry(!isInside);
  }
}

class MarkExitHandler {
  PolygonModel? model;
  bool isExiting;
  final Api api;
  Timer? timer;
  final _duration = const Duration(seconds: 20);

  Timer? logger;

  MarkExitHandler({
    required this.model,
    this.isExiting = false,
    required this.api,
    this.timer,
  });

  void callExit(PolygonModel? polygonModel, [bool isExiting = false]) {
    model = polygonModel;
    this.isExiting = isExiting;
    // cancel();
    if (!(timer?.isActive ?? false)) {
      timer = Timer(_duration, callback);
      printTimer();
    }
    // if (!isExiting) cancel();
  }

  void printTimer() {
    var seconds = 20;
    logger = Timer.periodic(1.seconds, (_) => log('api will be called in ${seconds--}'));
    Future.delayed(_duration, logger?.cancel);
  }

  void cancel() {
    logger?.cancel();
    timer?.cancel();
  }

  Future<void> markExit() async {
    final result = await api.markExit(model!.id!);
    result.when(
      success: (s) {
        log('logbook exit date updated');
        cancel();
      },
      failure: (e) => {
        log(NetworkExceptions.getErrorMessage(e)),
      },
    );
  }

  void callback() {
    if (model != null && isExiting) {
      markExit();
    }
  }
}
