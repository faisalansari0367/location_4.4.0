// import 'package:api_repo/api_repo.dart';
// import 'package:bioplus/services/notifications/push_notifications.dart';
// import 'package:bioplus/ui/maps/location_service/geofence_service.dart';
// import 'package:bioplus/ui/maps/location_service/maps_api.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:workmanager/workmanager.dart';

// import 'constants/api_constants.dart';

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     // final _sharedPreference = await SharedPreferences.getInstance(); //Initialize dependency
    
//     final localApi = LocalApi();
//     final repo = ApiRepo(localApiinit: localApi.init);
//     await repo.init(baseUrl: ApiConstants.baseUrl, box: _box);
//     final mapsRepo = MapsApi(client: repo.client);

//     final geofenceService = GeofenceService.init(mapsRepo, repo);
//     final PushNotificationService _pushNotificationService = PushNotificationService();
//     await _pushNotificationService.showNotification(
//       title: 'Bioplus',
//       body: 'This is a test notification',
//     );

//     return Future.value(true);
//   });
// }

// void initWorkManager() async {
//   var workmanager = Workmanager();
//   await workmanager.initialize(callbackDispatcher, isInDebugMode: kDebugMode);
//   await workmanager.registerPeriodicTask(
//     "1",
//     "simplePeriodicTask",
//     frequency: Duration(minutes: 1),
//   );
// }
