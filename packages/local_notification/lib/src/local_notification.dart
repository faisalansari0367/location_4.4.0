import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  // static final _notificationService = NotificationService._internal();
  // static const String applicationName = 'Adani Saksham';
  final AwesomeNotifications notifications;
  final String appName;
  final String channelName;
  final String channelKey;

  // static Timer timer;
  // static bool alreadyShowingNotification = false;

  const NotificationService({
    required this.notifications,
    required this.appName,
    required this.channelName,
    required this.channelKey,
  });

  // NotificationService._internal();

  // static const channel_id = 'com.adani.saksham';

  // Future<void> init() async {
  //   final initializationSettingsAndroid = AndroidInitializationSettings('logo');

  //   final initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid,
  //     iOS: null,
  //     macOS: null,
  //   );

  //   await flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     onSelectNotification: selectNotification,
  //   );

  //   // await scheduleWeeklyNotifications(Time(9));
  //   // await scheduleWeeklyNotifications(Time(21));
  // }

  // Future selectNotification(String payload) async {
  //   log('notification selected');
  // }

  // var id = 0;
  // void showNotification() async {
  //   if (alreadyShowingNotification) return;
  //   alreadyShowingNotification = true;
  //   _notification();
  //   timer = Timer.periodic(Duration(minutes: 5), (timer) {
  //     _notification();
  //   });
  // }
  Future<bool> showNotification({required String message, required String title, int? id}) async {
    return await notifications.createNotification(
      content: NotificationContent(
        notificationLayout: NotificationLayout.Default,
        id: id ?? Random().nextInt(2147483647),
        title: title,
        category: NotificationCategory.Message,
        body: message,
        channelKey: channelKey,
      ),
    );
  }

  // Future<void> scheduleNotification({DateTime time, String title, String body, int id}) async {
  //   final now = time ?? DateTime.now().add(Duration(seconds: 5));
  //   final location = await TimeZone().getLocation();
  //   final tzDateTime = tz.TZDateTime.from(now, location);
  //   final details = const NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       channel_id,
  //       applicationName,
  //       'To remind you about your trip',
  //     ),
  //   );

  //   final notificationId = id ?? Random().nextInt(10000);

  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     notificationId,
  //     applicationName,
  //     body ?? 'Please clock in to start your day',
  //     tzDateTime,
  //     details,
  //     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //     androidAllowWhileIdle: true,
  //     // matchDateTimeComponents: DateTimeComponents.dateAndTime,
  //   );
  // }

}
