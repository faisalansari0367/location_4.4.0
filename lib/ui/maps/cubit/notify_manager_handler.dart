import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../widgets/dialogs/dialog_service.dart';
import '../location_service/maps_repo.dart';
import '../models/polygon_model.dart';
import '../view/widgets/dialog/notify_manager.dart';

class NotifyManagerHandler {
  late MapsRepo mapsRepo;
  // NotifyManagerHandler(
  //   this.mapsRepo, {
  //   this.duration = const Duration(minutes: 15),
  // });

  Timer? _timer;
  LatLng? position;
  PolygonModel? polygon;
  Timer? logger;
  late Duration duration = Duration(minutes: 10);

  static final NotifyManagerHandler _instance = NotifyManagerHandler._internal();

  factory NotifyManagerHandler() {
    return _instance;
  }

  NotifyManagerHandler._internal();

  void init(MapsRepo mapsRepo) {
    this.mapsRepo = mapsRepo;
  }

  // const NotifyManagerHandler(this.mapsRepo, this.duration);

  void updateData(LatLng position, PolygonModel? polygon) {
    this.position = position;
    this.polygon = polygon;
    call();
  }

  /// this function will be called after the duration passed while instantiating the class
  void call() {
    if (!(_timer?.isActive ?? false)) {
      _timer = Timer(
        duration,
        () {
          log('notified manager');
          cancel();
        },
      );
      // int seconds = 0;
      // logger = Timer.periodic(1.seconds, (_) {
      //   log('notification manager timer ${seconds++}');
      // });
    }
  }

  Future<void> _notifyManager() async {
    if (position == null || polygon == null) return;
    final result = await mapsRepo.notifyManager(
      polygon!.pic!,
      position!.latitude.toString(),
      position!.longitude.toString(),
      polygon!.id!,
    );
    result.when(
      success: (s) {
        if (Get.currentRoute != '/MapsPage') return;
        final message =
            'Notified ${polygon!.createdBy!.fullName} of your entry into zone ${polygon!.name} without a Declaration';
        DialogService.showDialog(
          child: NotifyManagerDialog(
            message: message,
          ),
        );
      },
      failure: (e) => DialogService.failure(error: e),
    );
  }

  void cancel() {
    _timer?.cancel();
    logger?.cancel();
  }
}
