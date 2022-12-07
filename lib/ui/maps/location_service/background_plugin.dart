// import 'dart:async';
// import 'dart:developer';
// import 'dart:isolate';
// import 'dart:ui';

// import 'package:background_location/main.dart';
// import 'package:carp_background_location/carp_background_location.dart';

// class BackgroundPlugin {
//   ReceivePort port = ReceivePort();
//   static const String _isolateName = "LocatorIsolate";

//   // IsolateNameServer.registerPortWithName(
//   //       port.sendPort, LocationServiceRepository.isolateName);
//   @pragma('vm:entry-point')
//   static void callback(LocationDto locationDto) async {
//     final send = IsolateNameServer.lookupPortByName(_isolateName);
//     send?.send(locationDto);
//   }

//   void init() async {
//     IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
//     port.listen((dynamic data) {
//       // do something with data
//       log('data: $data');
//     });

//     await initPlatformState();
//     await startLocator();
//   }

//   void dispose() {
//     IsolateNameServer.removePortNameMapping(_isolateName);
//     // DeviceBackgroundLocation.unRegisterLocationUpdate();
//   }

//   Future<void> initPlatformState() async {
//     // await DeviceBackgroundLocation.initialize();
//   }

//   // void onStop() async {
//   //   await DeviceBackgroundLocation.unRegisterLocationUpdate();
//   //   final _isRunning = await DeviceBackgroundLocation.isServiceRunning();
//   // }

//   // void _onStart() async {
//   //   if (await _checkLocationPermission()) {
//   //     await _startLocator();
//   //     final _isRunning = await DeviceBackgroundLocation.isServiceRunning();
//   //   } else {
//   //     // show error
//   //   }
//   // }

//   Future<void> startLocator() async {
//     Map<String, dynamic> data = {'countInit': 1};
//     LocationManager().interval = 1;
//     LocationManager().distanceFilter = 0;
//     LocationManager().notificationTitle = 'CARP Location Example';
//     LocationManager().notificationMsg = 'CARP is tracking your location';
//     StreamSubscription<LocationDto> locationSubscription = LocationManager().locationStream.listen((LocationDto p1) {
//       showNotification(title: 'monitoring location', body: 'lat: ${p1.latitude}, long: ${p1.longitude}');
//     });
//     // return await DeviceBackgroundLocation.registerLocationUpdate(
//     //   callback,
//     //   initCallback: _initCallback,
//     //   initDataCallback: data,
//     //   disposeCallback: _disposeCallback,
//     //   iosSettings: IOSSettings(accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
//     //   autoStop: false,
//     //   androidSettings: AndroidSettings(
//     //     accuracy: LocationAccuracy.HIGH,
//     //     interval: 0,
//     //     distanceFilter: 0,
//     //     client: LocationClient.google,
//     //     androidNotificationSettings: AndroidNotificationSettings(
//     //       notificationChannelName: 'Location tracking',
//     //       notificationTitle: 'Start Location Tracking',
//     //       notificationMsg: 'Track location in background',
//     //       notificationBigMsg:
//     //           'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
//     //       notificationIconColor: Colors.grey,
//     //       notificationTapCallback: _onTapNotification,
//     //     ),
//     //   ),
//     // );
//   }

//   void _callback(LocationDto p1) {
//     showNotification(title: 'monitoring location', body: 'lat: ${p1.latitude}, long: ${p1.longitude}');
//   }

//   void _initCallback(Map<String, dynamic> p1) {
//     print(p1);
//   }

//   void _disposeCallback() {
//     print('dispose');
//   }

//   void _onTapNotification() {
//     print('tap notification');
//   }
// }
