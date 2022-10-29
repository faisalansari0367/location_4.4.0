import 'package:api_repo/api_result/api_result.dart';

import '../../user/src/models/logbook_entry_model.dart';

abstract class LogRecordsRepo {
  Future<ApiResult<LogbookResponseModel>> getLogbookRecords({int page = 1});
  Future<ApiResult<LogbookEntry>> createLogRecord(String geofenceId, {String? form});
  // Future<ApiResult<LogbookEntry>> updateLogRecord(int logId, String geofenceId);
  Future<ApiResult<LogbookEntry>> udpateForm(String geofenceId, String form, {int? logId});
  Future<ApiResult<LogbookEntry>> markExit(String geofenceId);
  Future<LogbookEntry?> getLogRecord(String geofenceId);

  Future<ApiResult<LogbookEntry>> logBookEntry(
    String pic,
    String geofenceId, {
    bool isExiting = false,
    String? form,
  });

  Stream<List<LogbookEntry>> get logbookRecordsStream;
}
