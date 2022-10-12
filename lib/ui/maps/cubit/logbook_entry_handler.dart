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

  LogbookEntryHandler({
    required this.api,
    this.polygonModel,
    required this.mapsRepo,
  });

  void _markExit() async {
    // Get.snackbar(
    //   "Please wait",
    //   "Updating exit time",
    //   snackPosition: SnackPosition.BOTTOM,
    // );
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
    // Get.snackbar(
    //   "Please wait",
    //   "Registering entry time",
    //   snackPosition: SnackPosition.BOTTOM,
    // );
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
