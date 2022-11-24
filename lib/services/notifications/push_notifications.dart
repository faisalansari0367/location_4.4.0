// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:background_location/widgets/dialogs/emergency_warning_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:local_notification/local_notification.dart';

import '../../constants/my_decoration.dart';

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await showNotification(
//     message.data['title'],
//     message.data['body'],
//     image: message.data['image'],
//   );
// }

class PushNotificationService {
  final NotificationService localNotificationService;
  PushNotificationService({
    required this.localNotificationService,
  });

  // Future<void> setBgHandler(Future<void> Function(RemoteMessage) handler) async {
  //  instance.onBackgroundMessage(handler);
  // }

  Future<void> initmessaging() async {
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.getInitialMessage().then((message) {});
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        if (message.notification?.title == 'WARNING!') {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
          DialogService.showDialog(child: EmergencyWarningDialog(message: message.notification?.body ?? ''));
          return;
        }
        if (message.notification?.title == 'USER ENTERED') {
          await _userEnteredInAZone(message);
          return;
        }
        if (message.notification?.title == 'USER EXITED') {
          await _userExitedFromZone(message);
          return;
        }
        final result = await localNotificationService.showNotification(
          title: message.notification?.title ?? '',
          message: message.notification?.body ?? '',
        );
        log('${message.notification?.toMap()} \n notification shown: $result');
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        localNotificationService.showNotification(
          title: ((message.data['title']) ?? '').toString(),
          message: ((message.data['body']) ?? '').toString(),
          // image: message.data['image'],
        );
      },
    );
  }

  Future<void> _userEnteredInAZone(RemoteMessage message) async {
    log(message.toString());
    final data = message.data;
    final geofenceName = data['geofenceName'];
    final date = DateTime.parse(data['date']).toLocal();
    final userName = data['userName'];
    await localNotificationService.showNotification(
      title: message.notification?.title ?? '',
      message: '$userName entered zone $geofenceName at ${MyDecoration.formatTime(date)}',
    );
  }

  Future<void> _userExitedFromZone(RemoteMessage message) async {
    log(message.toString());
    final data = message.data;
    final geofenceName = data['geofenceName'];
    final date = DateTime.parse(data['date']).toLocal();
    final userName = data['userName'];
    await localNotificationService.showNotification(
      title: message.notification?.title ?? '',
      message: '$userName exited zone $geofenceName at ${MyDecoration.formatTime(date)}',
    );
  }

  Future<String?> getFCMtoken() async {
    return FirebaseMessaging.instance.getToken();
  }
}
