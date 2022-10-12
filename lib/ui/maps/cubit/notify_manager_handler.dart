import 'dart:async';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../widgets/dialogs/dialog_service.dart';
import '../location_service/maps_repo.dart';
import '../models/polygon_model.dart';
import '../view/widgets/dialog/notify_manager.dart';

class NotifyManagerHandler {
  final MapsRepo mapsRepo;
  NotifyManagerHandler(this.mapsRepo, {this.duration = const Duration(minutes: 15)});
  final Duration duration;
  Timer? _timer;
  LatLng? position;
  PolygonModel? polygon;

  void updateData(LatLng position, PolygonModel? polygon) {
    this.position = position;
    this.polygon = polygon;
    call();
  }

  /// this function will be called after the duration passed while instantiating the class
  void call() {
    if (!(_timer?.isActive ?? false)) {
      _timer = Timer(duration, _notifyManager);
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
  }
}
