// import 'dart:developer';

// import 'package:background_locator/background_locator.dart';
// import 'package:background_locator/settings/android_settings.dart';
// import 'package:background_locator/settings/ios_settings.dart';
// import 'package:background_locator/settings/locator_settings.dart';
// import 'package:flutter/material.dart';

// import 'location_callback_handler.dart';

// Future<void> initBackgroundLocator() async {
//   await BackgroundLocator.initialize();
//   await startLocator();
//   final isServiceRunning = await BackgroundLocator.isServiceRunning();
//   log('isServiceRunning: $isServiceRunning');
// }

// Future<void> startLocator() async {
  
//   return await BackgroundLocator.registerLocationUpdate(
//     LocationCallbackHandler.callback,
//     initCallback: LocationCallbackHandler.initCallback,
//     // initDataCallback: data,
//     disposeCallback: LocationCallbackHandler.disposeCallback,
//     iosSettings: const IOSSettings(accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
//     autoStop: false,
//     androidSettings: const AndroidSettings(
//       accuracy: LocationAccuracy.NAVIGATION,
//       interval: 5,
//       distanceFilter: 0,
//       client: LocationClient.google,
//       androidNotificationSettings: AndroidNotificationSettings(
//         notificationChannelName: 'Location tracking',
//         notificationTitle: 'Start Location Tracking',
//         notificationMsg: 'Track location in background',
//         notificationBigMsg:
//             'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
//         notificationIconColor: Colors.grey,
//         notificationTapCallback: LocationCallbackHandler.notificationCallback,
//       ),
//     ),
//   );
// }
