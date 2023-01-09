// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:api_client/api_client.dart';
import 'package:api_repo/src/log/models/logbook_entry_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/subjects.dart';

import 'log_records_offline.dart';

abstract class _Keys {
  static const logRecords = 'logRecords';
}

class LogRecordsLocalService {
  LogRecordsLocalService({required this.box}) {
    offlineLogRecords = OfflineLogRecordsImpl(box: box);
    getLogbookRecords();
    box.watch(key: _Keys.logRecords).listen((event) {
      if (event.value == null) return;
      // log(jsonEncode(event.value));
      final responseModel =
          LogbookResponseModel.fromJson(_parseData(event.value)!);
      _controller.add(responseModel.data!);
    });
  }

  final Box box;
  late OfflineLogRecordsImpl offlineLogRecords;

  final _controller = BehaviorSubject<List<LogbookEntry>>.seeded([]);

  Future<ApiResult<LogbookResponseModel>> getLogbookRecords() async {

    final data = box.get(_Keys.logRecords);
    if (data == null) {
      return ApiResult.success(data: LogbookResponseModel(data: []));
    }
    final responseModel = LogbookResponseModel.fromJson(_parseData(data)!);
    _controller.add(responseModel.data!);
    return ApiResult.success(data: responseModel);
  }

  Future<ApiResult<LogbookResponseModel>> saveLogbookRecords(
      LogbookResponseModel logbookResponseModel) async {
    try {
      logbookResponseModel.data!.sort((a, b) => b.id!.compareTo(a.id!));
      final json = logbookResponseModel.toJson();
      await box.put(_Keys.logRecords, json);
      return ApiResult.success(data: logbookResponseModel);
    } catch (e) {
      return ApiResult.failure(
          error: NetworkExceptions.defaultError(e.toString()));
    }
  }

  Map<String, dynamic>? _parseData(data) {
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  List<LogbookEntry> get logRecords => _controller.value;
  Stream<List<LogbookEntry>> get logbookRecordsStream => _controller.stream;
}
