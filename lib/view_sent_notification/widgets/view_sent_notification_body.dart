import 'package:api_repo/api_repo.dart';
import 'package:bioplus/view_sent_notification/provider/provider.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/index.dart';
import '../../widgets/expanded_tile.dart';
import '../../widgets/listview/my_listview.dart';

/// {@template view_sent_notification_body}
/// Body of the ViewSentNotificationPage.
///
/// Add what it does
/// {@endtemplate}
class ViewSentNotificationBody extends StatelessWidget {
  /// {@macro view_sent_notification_body}
  const ViewSentNotificationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text('View sent notifications'.capitalize!),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/export.png',
              width: 30,
            ),
            onPressed: context.read<ViewSentNotificationNotifier>().generateCsv,
          ),
        ],
      ),
      body: _body(),
    );
  }

  Consumer<ViewSentNotificationNotifier> _body() {
    return Consumer<ViewSentNotificationNotifier>(
      builder: (context, state, child) {
        return MyListview(
          spacing: Container(height: 2, color: Colors.grey.shade200),
          isLoading: state.baseState.isLoading,
          itemBuilder: (c, i) => _itemBuilder(state.data[i]),
          data: state.data,
        );
      },
    );
  }

  Widget _itemBuilder(SentNotification item) {
    return ExpandedTile(
      subtitle: SizedBox.shrink(),
      title: Text(
        MyDecoration.formatDate(item.notificationDate) + '\n' + MyDecoration.formatTime(item.notificationDate),
      ),
      trailing: Column(
        children: [
          Text(item.geofence?.name ?? ''),
          Text('Notified ${item.user?.length ?? 0} users'),
        ],
      ),
      children: (item.user ?? [])
          .map(
            (e) => Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: Colors.grey.shade200,
              child: Text(e),
            ),
          )
          .toList(),
    );
  }
}
