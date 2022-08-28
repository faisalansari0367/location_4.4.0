// // ignore_for_file: public_member_api_docs, sort_constructors_first


// import 'package:firebase_messaging/firebase_messaging.dart';

// import '../local_notification.dart';

// // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   await showNotification(
// //     message.data['title'],
// //     message.data['body'],
// //     image: message.data['image'],
// //   );
// // }

// class PushNotificationService {
//   final NotificationService localNotificationService;
//   final FirebaseMessaging instance;
//   PushNotificationService({
//     required this.instance,
//     required this.localNotificationService,
//   });

//   // Future<void> setBgHandler(Future<void> Function(RemoteMessage) handler) async {
//   //  instance.onBackgroundMessage(handler);
//   // }

//   Future<void> initmessaging() async {
//    instance.requestPermission();
//    instance.getInitialMessage().then((message) {});
//     //instance.onBackgroundMessage((RemoteMessage message) async {
//     //   await localNotificationService.showNotification(
//     //     title: message.data['title'],
//     //     message: message.data['body'],
//     //   );
//     // });

//   //  instance.onMessage.listen(
//   //     (RemoteMessage message) {
//   //       log(message.toString());
//   //       localNotificationService.showNotification(
//   //         title: (message.data['title']) ?? '',
//   //         message: (message.data['body']) ?? '',
//   //         // image: message.data['image'],
//   //       );
//   //     },
//   //   );

//   //  instance.onMessageOpenedApp.listen(
//   //     (RemoteMessage message) {
//   //       localNotificationService.showNotification(
//   //         title: (message.data['title']) ?? '',
//   //         message: (message.data['body']) ?? '',
//   //         // image: message.data['image'],
//   //       );
//   //     },
//   //   );
//   }

//   Future<String?> getFCMtoken() async {
//     returninstance.instance.getToken();
//   }
// }
