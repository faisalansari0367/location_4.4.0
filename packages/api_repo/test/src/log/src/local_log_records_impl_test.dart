import 'package:api_repo/api_repo.dart';
import 'package:api_repo/src/log/src/log_records_helper.dart';
import 'package:flutter_test/flutter_test.dart';

import 'data.dart';

class _LocalLogStorageService implements LogRecordsLocalStorage {
  List<LogbookEntry> _logRecords = [];
  _LocalLogStorageService() {
    final logRecords = LogbookResponseModel.fromJson(data);
    _logRecords = logRecords.data!;
  }

  @override
  Future<ApiResult<LogbookResponseModel>> getLogbookRecords() {
    // TODO: implement getLogbookRecords
    throw UnimplementedError();
  }

  @override
  // TODO: implement logRecords
  List<LogbookEntry> get logRecords => _logRecords;

  @override
  // TODO: implement logbookRecordsStream
  Stream<List<LogbookEntry>> get logbookRecordsStream =>
      throw UnimplementedError();

  @override
  Future<ApiResult<LogbookResponseModel>> saveLogbookRecords(
      LogbookResponseModel logbookResponseModel) {
    // TODO: implement saveLogbookRecords
    throw UnimplementedError();
  }
}

void main() {
  final records = _LocalLogStorageService();
  final repo = LogRecordsHelper(userId: 7, storage: records);

  test('testing storage', () async {
    expect(records.logRecords.length, 100);

    final record = await repo.getLogRecord(geofenceId: '130');
    expect(record, isNotNull);
    expect(record?.id, 2396);
  });
}
