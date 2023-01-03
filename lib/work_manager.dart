import 'package:api_repo/api_repo.dart';
import 'package:bioplus/services/notifications/push_notifications.dart';
import 'package:bioplus/ui/maps/location_service/geofence_service.dart';
import 'package:bioplus/ui/maps/location_service/maps_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:workmanager/workmanager.dart';

import 'constants/api_constants.dart';
import 'constants/hive_boxes.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // final _sharedPreference = await SharedPreferences.getInstance(); //Initialize dependency
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Hive.initFlutter();
    final _box = await Hive.openBox(HiveBox.storage);
    final localApi = LocalApi();
    final repo = ApiRepo(localApiinit: localApi.init);
    await repo.init(baseUrl: ApiConstants.localUrl, box: _box);
    final mapsRepo = MapsApi(client: repo.client);
    await mapsRepo.init();
    final geofenceService = GeofenceService();
    geofenceService.init(mapsRepo, repo);
    final PushNotificationService _pushNotificationService = PushNotificationService();
    await _pushNotificationService.showNotification(
      title: 'Bioplus',
      body: 'Fetching location data',
    );

    return Future.value(true);
  });
}

void initWorkManager() async {
  var workmanager = Workmanager();
  await workmanager.initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  await workmanager.registerPeriodicTask(
    "1",
    "fetch_location_data",
    frequency: Duration(minutes: 1),
  );
}
