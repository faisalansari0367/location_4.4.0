import 'dart:async';
import 'dart:ui';

import 'package:bioplus/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:get/get.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  // const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //   'my_foreground', // id
  //   'MY FOREGROUND SERVICE', // title
  //   description: 'This channel is used for important notifications.', // description
  //   importance: Importance.low, // importance must be at low or higher level
  // );

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // if (Platform.isIOS) {
  //   await flutterLocalNotificationsPlugin.initialize(
  //     const InitializationSettings(
  //       iOS: IOSInitializationSettings(),
  //     ),
  //   );
  // }

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      autoStartOnBoot: true,
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  Timer.periodic(1.seconds, (timer) {
    showNotification(
      title: 'AWESOME SERVICE',
      body: 'running on background',
    );
  });
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  // Only available for flutter 3.0.0 and later
  // For flutter prior to version 3.0.0
  // We have to register the plugin manually
  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // await preferences.setString("hello", "world");
  /// OPTIONAL when use custom notification
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      // service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    // service.on('stopService').listen((event) {
    //   service.stopSelf();
    // });

    // bring to foreground
    /// you can see this log in logcat
    // test using external plugin
    //   service.invoke(
    //     'update',
    //     {
    //       "current_date": DateTime.now().toIso8601String(),
    //       "device": device,
    //     },
    //   );
    // });
  }
}
