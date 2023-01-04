import 'package:api_repo/api_repo.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/services/notifications/sync_service.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:provider/provider.dart';

import '../../../services/notifications/push_notifications.dart';

class DashboardNotifier extends BaseModel {
  DashboardNotifier(BuildContext context) : super(context) {
    _init(context);
    // _userDataStream();
  }

  // bool _isVisitor = true;

  UserData? get userData => api.getUserData();
  bool get isVisitor => userData?.role == 'Visitor';

  void _init(BuildContext context) async {
    if (api.isInit) return;
    api.setIsInit(true);
    SyncService().init(localApi, api);
    // final mapsApi = context.read<MapsRepo>();
    final notificationService = context.read<PushNotificationService>();

    final user = api.getUser();
    if (user != null) {
      user.registerationToken = await notificationService.getFCMtoken();
      await api.updateMe(user: user);
    }
    await geofenceRepo.getAllPolygon();
    api.getLogbookRecords();
  }
}
