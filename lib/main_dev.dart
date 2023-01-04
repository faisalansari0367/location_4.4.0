import 'dart:async';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/hive_boxes.dart';
import 'package:bioplus/constants/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'my_app.dart';
import 'services/notifications/push_notifications.dart';

const enableCrashlytics = !kDebugMode;

Future<void> bgHandler(RemoteMessage message) async {
  final pushNotification = PushNotificationService();
  pushNotification.handleMessage(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setOrientation();
  await runZonedGuarded(() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Hive.initFlutter();
    final _box = await Hive.openBox(HiveBox.storage);
    final localApi = LocalApi();
    final repo = ApiRepo(localApiinit: localApi.init);
    await repo.init(baseUrl: ApiConstants.localUrl, box: _box);
    // final mapsRepo = MapsApi(client: repo.client);
    // await mapsRepo.init();

    final pushNotification = PushNotificationService();
    FirebaseMessaging.onBackgroundMessage(bgHandler);
    await pushNotification.initmessaging();
    // initWorkManager();
    runApp(
      MyApp(
        localApi: localApi,
        pushNotificationService: pushNotification,
        api: repo,
        // mapsRepo: mapsRepo,
      ),
    );

    if (enableCrashlytics) FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

Future<void> _setOrientation() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
