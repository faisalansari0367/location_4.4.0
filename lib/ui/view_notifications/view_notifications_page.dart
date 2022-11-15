import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:background_location/widgets/expanded_tile.dart';
import 'package:background_location/widgets/listview/my_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewSentNotifications extends StatefulWidget {
  const ViewSentNotifications({super.key});

  @override
  State<ViewSentNotifications> createState() => _ViewSentNotificationsState();
}

class _ViewSentNotificationsState extends State<ViewSentNotifications> {
  @override
  void initState() {
    context.read<Api>().getSentNotifications();
    super.initState();
  }

  Future<List<SentNotification>> _refresh() async {
    var data = <SentNotification>[];
    final result = await context.read<Api>().getSentNotifications();
    await result.when(success: (d) {
      data = d.data!;
    }, failure: (e) {
      DialogService.failure(error: e);
    });
    //  setState(() {

    //  });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Sent Notifications'),
      ),
      body: Container(
        child: FutureBuilder<List<SentNotification>>(
          // key: ValueKey('sentNotifications'),
          future: _refresh(),
          builder: (context, snapshot) {
            return MyListview(
              spacing: Container(
                height: 2,
                color: Colors.grey.shade200,
              ),
              isLoading: snapshot.connectionState == ConnectionState.waiting,
              itemBuilder: (c, i) => _itemBuilder(snapshot.data![i]),
              data: snapshot.data ?? [],
            );
          },
        ),
      ),
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
