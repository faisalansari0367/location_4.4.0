// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';

import '../location_service/maps_repo.dart';
import '../models/polygon_model.dart';

class LogbookEntryHandler {
  PolygonModel? polygonModel;
  bool? isExiting;
  MapsRepo mapsRepo;
  Api api;

  // final _debouncer = Debouncer(delay: 100.seconds);
  MarkExitHandler? markExitHandler;

  LogbookEntryHandler({
    required this.api,
    this.polygonModel,
    required this.mapsRepo,
  }) {
    markExitHandler = MarkExitHandler(
      api: api,
      model: polygonModel,
    );
  }

  void cancel() {
    markExitHandler?.cancel();
  }

  void _logbookEntry([bool isExiting = false]) async {
    // log('isExiting $isExiting \n polygonModel ${polygonModel?.toJson()}');
    if (polygonModel == null) return;
    if (isExiting) {
      markExitHandler?.callExit(polygonModel, isExiting);
      return;
    }
    final result = await api.logBookEntry(
      polygonModel!.pic!,
      polygonModel!.id!,
      isExiting: isExiting,
    );
    result.when(
      success: (s) => log('logbook entry success'),
      failure: (e) => log(NetworkExceptions.getErrorMessage(e)),
    );
  }

  Future<void> update(bool isInside, PolygonModel polygonModel) async {
    if (this.isExiting == isInside) return;
    this.isExiting = isInside;
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
  final _duration = Duration(seconds: 10);

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
    timer = Timer(_duration, callback);
    cancel();
    // printTimer();
  }

  // void printTimer() {
  //   var seconds = _duration.inSeconds;
  //   logger = Timer.periodic(1.seconds, (_) {
  //     log('api will be called in ${seconds - 1}');
  //   });
  // }

  void cancel() {
    logger?.cancel();
    timer?.cancel();
  }

  void markExit() async {
    cancel();
    final result = await api.markExit(model!.id!);
    result.when(
      success: (s) {
        log('logbook exit date updated');
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
