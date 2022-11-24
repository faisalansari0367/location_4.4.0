import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/src/log/models/logbook_entry_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/subjects.dart';

abstract class _Keys {
  static const logRecords = 'logRecords';
}

class LogRecordsLocalService {
  final Box box;
  LogRecordsLocalService({required this.box}) {
    _init();
  }

  void _init() async {
    final data = await getLogbookRecords();
    data.when(
      success: (s) => _controller.add(s.data ?? []),
      failure: (f) {},
    );
    box.watch(key: _Keys.logRecords).listen((event) {
      if (event.value == null) {
        return;
      }
      final data = LogbookResponseModel.fromJson(_parseData(event.value)!).data;
      _controller.add(data!);
    });
  }

  final _controller = BehaviorSubject<List<LogbookEntry>>.seeded([]);

  Future<ApiResult<LogbookEntry>> saveLogRecord(String geofenceId, LogbookEntry logbookEntry) async {
    try {
      await box.put(geofenceId, logbookEntry.toJson());
      return ApiResult.success(data: logbookEntry);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.defaultError(e.toString()));
    }
  }

  LogbookEntry? getLogRecord(String geofenceId) {
    try {
      final data = _parseData(box.get(geofenceId));
      if (data == null) return null;
      return LogbookEntry.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setLogRecord(String geofenceId, LogbookEntry logbookEntry) async {
    try {
      await (box.put(geofenceId, logbookEntry.toJson()));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeLogRecord(String geofenceId) async {
    try {
      await box.delete(geofenceId);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResult<LogbookResponseModel>> getLogbookRecords() async {
    final data = _parseData(box.get(_Keys.logRecords));
    if (data == null) return ApiResult.success(data: LogbookResponseModel(data: []));
    final responseModel = LogbookResponseModel.fromJson(_parseData(data)!);
    return ApiResult.success(data: responseModel);
  }

  Future<ApiResult<LogbookResponseModel>> saveLogbookRecords(LogbookResponseModel logbookResponseModel) async {
    try {
      final json = logbookResponseModel.toJson();
      await box.put(_Keys.logRecords, json);
      return ApiResult.success(data: logbookResponseModel);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.defaultError(e.toString()));
    }
  }

  Map<String, dynamic>? _parseData(data) {
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  Future<ApiResult<LogbookEntry>> updateLogRecord(String geofenceId, LogbookEntry logbookEntry) async {
    try {
      await box.put(geofenceId, logbookEntry.toJson());
      return ApiResult.success(data: logbookEntry);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.defaultError(e.toString()));
    }
  }

  List<LogbookEntry> get logRecords => _controller.value;
  Stream<List<LogbookEntry>> get logbookRecordsStream => _controller.stream;
}
