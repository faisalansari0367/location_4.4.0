import 'dart:async';
import 'dart:developer';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/maps/view/widgets/dialog/notify_manager.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NotifyManagerHandler {
  late GeofencesRepo mapsRepo;
  // NotifyManagerHandler(
  //   this.mapsRepo, {
  //   this.duration = const Duration(minutes: 15),
  // });

  Timer? _timer;
  LatLng? position;
  PolygonModel? polygon;
  Timer? logger;
  late Duration duration = const Duration(seconds: 180);

  static final NotifyManagerHandler _instance = NotifyManagerHandler._internal();

  factory NotifyManagerHandler() {
    // _instance.duration = duration;
    return _instance;
  }

  NotifyManagerHandler._internal();

  void init(GeofencesRepo mapsRepo) {
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
    log('calling notify manager');
    if (!(_timer?.isActive ?? false)) {
      _timer = Timer(
        duration,
        () {
          log('notified manager');
          _notifyManager();
          cancel();
        },
      );
    }
  }

  Future<void> _notifyManager() async {
    if (position == null || polygon == null) return;
    final result = await mapsRepo.notifyManager(
      // polygon!.pic!,
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
