
import 'package:api_client/api_result/api_result.dart';

import '../models/models.dart';

abstract class LogRecordsRepo {
  Future<ApiResult<LogbookResponseModel>> getLogbookRecords({int page = 1, int limit = 100});
  Future<ApiResult<LogbookEntry>> createLogRecord(String geofenceId, {String? form});
  // Future<ApiResult<LogbookEntry>> updateLogRecord(int logId, String geofenceId);
  Future<ApiResult<LogbookEntry>> udpateForm(String geofenceId, Map<String, dynamic> form, {int? logId});
  Future<ApiResult<LogbookEntry>> markExit(String geofenceId);
  Future<ApiResult<LogbookEntry>> markExitById(String logRecordId);

  Future<LogbookEntry?> getLogRecord(String geofenceId);

  Future<ApiResult<LogbookEntry>> logBookEntry(
    String pic,
    String geofenceId, {
    bool isExiting = false,
    String? form,
  });

  Future<bool> synchronizeLogRecords();

  Stream<List<LogbookEntry>> get logbookRecordsStream;
  List<LogbookEntry> get logbookRecords;
}
