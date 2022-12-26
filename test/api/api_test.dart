
import 'package:api_repo/api_repo.dart';
import 'package:api_repo/configs/client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  const url = 'http://13.55.174.146:3000';

  await Hive.initFlutter();
  final _box = await Hive.openBox('storage');
  final LogRecordsImpl api = LogRecordsImpl(client: Client(baseUrl: url), box: _box);
  // final notifications = AwesomeNotifications();
  // final repo = ApiRepo();
  // final localApi = LocalApi();
  // await repo.init(baseUrl: url, box: _box);
  // await localApi.init(baseUrl: url, box: _box);
  test('log records impl ...', () async {
    final logRecords = api.storage.logRecords;
    final offlineLogRecords = api.storage.offlineLogRecords.logRecords;

    expect(offlineLogRecords.length, 1);

    // api.synchronizeLogRecords();
  });
}
