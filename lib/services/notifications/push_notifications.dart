// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bioplus/constants/my_decoration.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/dialogs/emergency_warning_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await showNotification(
//     message.data['title'],
//     message.data['body'],
//     image: message.data['image'],
//   );
// }

class PushNotificationService {
  // final NotificationService localNotificationService;
  static late AwesomeNotifications _notifications;
  static bool _initialized = false;
  static final Completer<void> _completer = Completer<void>();
  PushNotificationService() {
    _notifications = AwesomeNotifications();
    init();
  }

  // Future<void> setBgHandler(Future<void> Function(RemoteMessage) handler) async {
  //  instance.onBackgroundMessage(handler);
  // }

  Future<bool> init() async {
    // final AwesomeNotifications notifications = AwesomeNotifications();
    if (_initialized) return true;
    final result = await _notifications.initialize(
      'resource://drawable/itrak_logo_transparent',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color.fromARGB(255, 0, 0, 0),
          ledColor: Colors.white,
        )
      ],
      debug: kDebugMode,
    );
    _initialized = result;
    if (!_completer.isCompleted) {
      _completer.complete();
    }
    return result;
  }

  Future<bool> showNotification({
    required String title,
    required String body,
    int? id,
  }) async {
    if (!_initialized) {
      await _completer.future;
    }
    final result = await _notifications.createNotification(
      content: NotificationContent(
        notificationLayout: NotificationLayout.BigText,
        id: id ?? Random().nextInt(2147483647),
        title: title,
        category: NotificationCategory.Message,
        body: body,
        channelKey: 'basic_channel',
      ),
    );
    return result;
  }

  Future<void> initmessaging() async {
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getInitialMessage().then((message) {});
    FirebaseMessaging.onMessage.listen(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOnMessageOpenedApp);
  }

  void _handleOnMessageOpenedApp(RemoteMessage message) {
    showNotification(
      title: ((message.data['title']) ?? '').toString(),
      body: ((message.data['body']) ?? '').toString(),
    );
  }

  Future<void> handleMessage(RemoteMessage message, {bool inBackground = false}) async {
    final title = message.notification?.title;
    switch (title) {
      case 'WARNING!':
        _handleWarningMessage(inBackground, message);
        break;
      case 'USER ENTERED':
        await _handleUserVisit(message);
        break;
      case 'USER EXITED':
        await _handleUserVisit(message, isEntered: false);
        break;
      default:
        await _showRemoteNotification(message);
        break;
    }
  }

  void _handleWarningMessage(bool inBackground, RemoteMessage message) {
    if (!inBackground) {
      _hidePopUp();
      DialogService.showDialog(
        child: EmergencyWarningDialog(message: message.notification?.body ?? ''),
      );
    } else {
      _showRemoteNotification(message);
    }
  }

  Future<void> _showRemoteNotification(RemoteMessage message) async {
    final result = await showNotification(
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
    );
    log('${message.notification?.toMap()} \n notification shown: $result');
  }

  void _hidePopUp() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  Future<void> _handleUserVisit(RemoteMessage message, {bool isEntered = true}) async {
    log(message.toString());
    final data = message.data;
    final geofenceName = data['geofenceName'];
    final date = DateTime.parse(data['date']).toLocal();
    final userName = data['userName'];
    await showNotification(
      title: message.notification?.title ?? '',
      body: '$userName ${_getVisitType(isEntered)} zone $geofenceName at ${MyDecoration.formatTime(date)}',
    );
  }

  String _getVisitType(bool isEntered) => isEntered ? 'entered' : 'exited';

  Future<String?> getFCMtoken() async => FirebaseMessaging.instance.getToken();
}
