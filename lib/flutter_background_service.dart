// import 'package:background_fetch/background_fetch.dart';
// import 'package:bioplus/main.dart';
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

// /// Receive events from BackgroundGeolocation in Headless state.
// @pragma('vm:entry-point')
// void backgroundGeolocationHeadlessTask(bg.HeadlessEvent headlessEvent) async {
//   print('📬 --> $headlessEvent');

//   switch (headlessEvent.name) {
//     case bg.Event.BOOT:
//       bg.State state = await bg.BackgroundGeolocation.state;
//       print("📬 didDeviceReboot: ${state.didDeviceReboot}");
//       break;
//     case bg.Event.TERMINATE:
//       try {
//         bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(
//             samples: 1, extras: {"event": "terminate", "headless": true});
//         print("[getCurrentPosition] Headless: $location");
//         showNotification(title: '[getCurrentPosition] Headless', body: location.toString());
//       } catch (error) {
//         print("[getCurrentPosition] Headless ERROR: $error");
//       }

//       break;
//     case bg.Event.HEARTBEAT:
//       /* DISABLED getCurrentPosition on heartbeat
//       try {
//         bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition(
//           samples: 1,
//           extras: {
//             "event": "heartbeat",
//             "headless": true
//           }
//         );
//         print('[getCurrentPosition] Headless: $location');
//       } catch (error) {
//         print('[getCurrentPosition] Headless ERROR: $error');
//       }
//       */
//       break;
//     case bg.Event.LOCATION:
//       bg.Location location = headlessEvent.event;
//       print(location);
//       break;
//     case bg.Event.MOTIONCHANGE:
//       bg.Location location = headlessEvent.event;
//       print(location);
//       break;
//     case bg.Event.GEOFENCE:
//       bg.GeofenceEvent geofenceEvent = headlessEvent.event;
//       print(geofenceEvent);
//       break;
//     case bg.Event.GEOFENCESCHANGE:
//       bg.GeofencesChangeEvent event = headlessEvent.event;
//       print(event);
//       break;
//     case bg.Event.SCHEDULE:
//       bg.State state = headlessEvent.event;
//       print(state);
//       break;
//     case bg.Event.ACTIVITYCHANGE:
//       bg.ActivityChangeEvent event = headlessEvent.event;
//       print(event);
//       break;
//     case bg.Event.HTTP:
//       bg.HttpEvent response = headlessEvent.event;
//       print(response);
//       break;
//     case bg.Event.POWERSAVECHANGE:
//       bool enabled = headlessEvent.event;
//       print(enabled);
//       break;
//     case bg.Event.CONNECTIVITYCHANGE:
//       bg.ConnectivityChangeEvent event = headlessEvent.event;
//       print(event);
//       break;
//     case bg.Event.ENABLEDCHANGE:
//       bool enabled = headlessEvent.event;
//       print(enabled);
//       break;
//     case bg.Event.AUTHORIZATION:
//       bg.AuthorizationEvent event = headlessEvent.event;
//       print(event);
//       // bg.BackgroundGeolocation.setConfig(
//       // bg.Config(url: "${ENV.TRACKER_HOST}/api/locations"));
//       break;
//   }
// }

// /// Receive events from BackgroundFetch in Headless state.
// @pragma('vm:entry-point')
// void backgroundFetchHeadlessTask(HeadlessTask task) async {
//   String taskId = task.taskId;

//   // Is this a background_fetch timeout event?  If so, simply #finish and bail-out.
//   if (task.timeout) {
//     print("[BackgroundFetch] HeadlessTask TIMEOUT: $taskId");
//     BackgroundFetch.finish(taskId);
//     return;
//   }

//   print("[BackgroundFetch] HeadlessTask: $taskId");

//   try {
//     var location = await bg.BackgroundGeolocation.getCurrentPosition(
//         samples: 1, extras: {"event": "background-fetch", "headless": true});
//     print("[location] $location");
//   } catch (error) {
//     print("[location] ERROR: $error");
//   }

//   // SharedPreferences prefs = await SharedPreferences.getInstance();
//   // int count = 0;
//   // if (prefs.get("fetch-count") != null) {
//   //   count = prefs.getInt("fetch-count");
//   // }
//   // prefs.setInt("fetch-count", ++count);
//   // print('[BackgroundFetch] count: $count');

//   BackgroundFetch.finish(taskId);
// }

// Future<void> registerGeofenceService() async {
//   await bg.BackgroundGeolocation.registerHeadlessTask(backgroundGeolocationHeadlessTask);

//   /// Register BackgroundFetch headless-task.
//   await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
// }
