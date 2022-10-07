// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:local_notification/local_notification.dart';

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
    // instance.onBackgroundMessage((RemoteMessage message) async {
    //   await localNotificationService.showNotification(
    //     title: message.data['title'],
    //     message: message.data['body'],
    //   );
    // });

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
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

  Future<String?> getFCMtoken() async {
    return FirebaseMessaging.instance.getToken();
  }
}
