import 'dart:async';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/my_decoration.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/services/csv_service.dart';
import 'package:bioplus/widgets/dialogs/dialogs.dart';
// ignore: depend_on_referenced_packages
import 'package:cross_file/cross_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class SosNotifier extends BaseModel {
  SosNotifier(super.context) {
    init();
  }
  List<SosNotification> _sosNotifications = [];

  List<SosNotification> get sosNotifications => _sosNotifications;

  Future<void> init() async {
    setLoading(true);
    final result = await api.getSosNotification();
    result.when(
      success: (data) {
        _sosNotifications = data;
        notifyListeners();
      },
      failure: (error) {
        DialogService.failure(error: error);
        notifyListeners();
      },
    );
    setLoading(false);
  }

  String date(SosNotification sos) =>
      MyDecoration.formatDate(sos.sosDate ?? sos.createdAt);
  String dateWithTime(SosNotification sos) =>
      MyDecoration.formatDateWithTime(sos.sosDate ?? sos.createdAt);

  Future<void> generateCsv() async {
    await Permission.storage.request();

    final csvService = CsvService(api);
    final List<String> headers = [
      'id',
      'sos date',
      'geofence',
      'created by',
      'phone number',
      'location url',
    ];

    final List<List<String>> rows = sosNotifications
        .map(
          (e) => <String>[
            e.id.toString(),
            dateWithTime(e),
            e.geofence?.name ?? '',
            e.createdBy?.fullName ?? '',
            '+${e.createdBy?.countryCode ?? ''}${e.createdBy?.phoneNumber ?? ''}',
            e.locationUrl,
          ],
        )
        .toList();

    try {
      final result = await csvService.generateCsv(
        headers,
        rows,
        fileName: 'SOS Notifications Report ${DateTime.now()}',
      );
      Share.shareXFiles([XFile(result.path)]);
    } on Exception {
      DialogService.error('Cannot generate csv file');
      // TODO
    }
  }
}
