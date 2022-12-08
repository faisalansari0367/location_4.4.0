import 'package:bioplus/view_sent_notification/provider/provider.dart';
import 'package:bioplus/view_sent_notification/widgets/view_sent_notification_body.dart';
import 'package:flutter/material.dart';

/// {@template view_sent_notification_page}
/// A description for ViewSentNotificationPage
/// {@endtemplate}
class ViewSentNotificationPage extends StatelessWidget {
  /// {@macro view_sent_notification_page}
  const ViewSentNotificationPage({super.key});

  /// The static route for ViewSentNotificationPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const ViewSentNotificationPage());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ViewSentNotificationNotifier(context),
      child: const Scaffold(
        body: ViewSentNotificationView(),
      ),
    );
  }
}

/// {@template view_sent_notification_view}
/// Displays the Body of ViewSentNotificationView
/// {@endtemplate}
class ViewSentNotificationView extends StatelessWidget {
  /// {@macro view_sent_notification_view}
  const ViewSentNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ViewSentNotificationBody();
  }
}
