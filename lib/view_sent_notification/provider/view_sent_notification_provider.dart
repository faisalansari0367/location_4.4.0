// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/provider/base_model.dart';
import 'package:background_location/services/notifications/forms_storage_service.dart';
import 'package:share_plus/share_plus.dart';

import '../../widgets/dialogs/dialog_service.dart';

class ViewSentNotificationNotifier extends BaseModel {
  var data = <SentNotification>[];

  ViewSentNotificationNotifier(super.context) {
    getSentNotifications();
  }

  Future<void> getSentNotifications() async {
    setLoading(true);
    final result = await api.getSentNotifications();
    await result.when(
      success: (d) {
        data = d.data!;
        setLoading(false);
      },
      failure: (e) {
        DialogService.failure(error: e);
        setLoading(false);
      },
    );
  }

  Future<void> generateCsv() async {
    final formsService = FormsStorageService(api);
    final headers = ['Date', 'Time', 'Zone', 'Users Notified'];
    final rows = data
        .map(
          (e) => [
            MyDecoration.formatDate(e.createdAt),
            MyDecoration.formatTime(e.createdAt),
            e.geofence?.name ?? '',
            (e.user?.isEmpty ?? true) ? 'No one to notify' : e.user!.join(', '),
          ],
        )
        .toList();
    final file = await formsService.generateCsv(
      headers,
      rows,
      fileName: 'Warning notifications report of ${api.getUser()?.fullName}',
    );
    await Share.shareFiles([file.path]);
  }
}
