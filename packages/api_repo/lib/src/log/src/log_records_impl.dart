import 'dart:async';
import 'dart:developer';

import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/configs/client.dart';
import 'package:api_repo/src/auth/src/storage/storage_service.dart';
import 'package:api_repo/src/log/log_records.dart';
import 'package:api_repo/src/user/src/models/logbook_entry_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../configs/endpoint.dart';

class LogRecordsImpl implements LogRecordsRepo {
  final Client client;
  final Box box;
  late LogRecordsLocalService storage;
  late StorageService storageService;

  final _completer = Completer<void>();

  List<LogbookEntry> _logRecords = [];
  // LogbookEntry? currentLogRecordEntry;

  /// [LogRecordsImpl] constructor
  LogRecordsImpl({required this.client, required this.box}) {
    storageService = StorageService(box: box);
    storage = LogRecordsLocalService(box: box);
    logbookRecordsStream.listen((event) => _logRecords = event);
    _logRecords = storage.logRecords;
  }

  int getDifference(DateTime? date) {
    if (date == null) return 0;
    final difference = DateTime.now().difference(date);
    return difference.inMinutes;
  }

  @override
  Future<ApiResult<LogbookEntry>> createLogRecord(String geofenceId, {String? form}) async {
    // int entryDifference = 0;
    // int exitDifference = 0;

    // if (_logRecords.isNotEmpty) {
    //   entryDifference = getDifference(_logRecords.first.enterDate);
    //   exitDifference = getDifference(_logRecords.first.exitDate);
    // }

    try {
      // if (_logRecords.first.exitDate != null) {
      //   if (exitDifference < 15) {
      //     return const ApiResult.failure(
      //       error: NetworkExceptions.defaultError(
      //         'No need to create a new log record in less than 15 minutes',
      //       ),
      //     );
      //   } else if (entryDifference < 15) {
      //     return const ApiResult.failure(
      //       error: NetworkExceptions.defaultError(
      //         'No need to create a new log record in less than 15 minutes',
      //       ),
      //     );
      //   }
      // }
      final data2 = {'form': form, 'geofenceID': geofenceId};
      if (form == null) data2.remove('form');
      final result = await client.post(Endpoints.logRecords, data: data2);
      final logbookEntry = LogbookEntry.fromJson(Map<String, dynamic>.from(result.data['data']));
      _logRecords.insert(0, logbookEntry);
      log('logRecord ${logbookEntry.id} created');
      return ApiResult.success(data: logbookEntry);
    } on DioError catch (e) {
      // final data = e.response?.data['data'] ?? {};
      // if (data?.containsKey('logRecord')) {
      //   // return ApiResult.failure(message: data['logRecord']);
      //   if (data != null) {
      //     return _updateLogRecord(data['logRecord'], geofenceId, form: form);
      //   }
      // }
      // ['logRecord'];
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<LogbookEntry>> markExit(String geofenceId) async {
    try {
      LogbookEntry? hasEntry = await getLogRecord(geofenceId);
      final result = await client.patch('${Endpoints.markExit}/${hasEntry!.id}');
      final logbookEntry = LogbookEntry.fromJson(Map<String, dynamic>.from(result.data['data']));
      _updateEntry(logbookEntry);
      return ApiResult.success(data: logbookEntry);
    } on DioError catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<LogbookResponseModel>> getLogbookRecords({int page = 1, int limit = 20}) async {
    try {
      // client.token = storageService.getToken();
      final queryParameters = {'page': page, 'limit': limit};
      final result = await client.get(Endpoints.logRecords, queryParameters: queryParameters);
      final data = LogbookResponseModel.fromJson(result.data);
      final ids = <int>{};
      // final difference = data.data!.toSet().difference(_logRecords.toSet());
      final records = <LogbookEntry>[..._logRecords, ...data.data!];
 
      for (var item in records) {
        ids.add(item.id!);
      }

      // final _filteredRecords = records.toSet().toList();
      // print(records.length);
      records.retainWhere((element) {
        final result = ids.contains(element.id!);
        if (result) ids.remove(element.id!);
        return result;
      });

      data.data = records;
      storage.saveLogbookRecords(data);
      if (!_completer.isCompleted) {
        _completer.complete();
      }
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  // Future<ApiResult<LogbookEntry>> _updateLogRecord(int logId, String geofenceId, {String? form}) async {
  //   try {
  //     final data = {'geofenceID': geofenceId};
  //     if (form != null) data['form'] = form;
  //     final result = await client.patch('${Endpoints.logRecords}/$logId', data: data);
  //     final json = Map<String, dynamic>.from(result.data['data']);
  //     final logbookEntry = LogbookEntry.fromJson(json);
  //     storage.updateLogRecord(geofenceId, logbookEntry);
  //     return ApiResult.success(data: logbookEntry);
  //   } on DioError catch (e) {
  //     final response = e.response?.data as Map;
  //     if (response['message'] == "Log Record does not exist") {
  //       return createLogRecord(geofenceId, form: form);
  //     }

  //     if (response['message'] == "You already exited this geofence") {
  //       final entry = getLogRecord(geofenceId);
  //     }
  //     final hasData = response.containsKey(['data']);
  //     if (!hasData) return ApiResult.failure(error: NetworkExceptions.getDioException(e));
  //     return ApiResult.failure(error: NetworkExceptions.getDioException(e));
  //   }
  // }

  @override
  Future<ApiResult<LogbookEntry>> logBookEntry(
    String pic,
    String geofenceId, {
    bool isExiting = false,
    String? form,
  }) async {
    try {
      // await storage.removeLogbookEntry(locationId);

      final hasEntry = await getLogRecord(geofenceId);
      // final difference = DateTime.now().difference(hasEntry?.enterDate ?? DateTime.now()).inMinutes;
      // final difference = hasEntry?.enterDate?.difference(DateTime.now()).inMinutes;
      // log('time difference is $difference');

      if (hasEntry == null) {
        // delay for 15 minutes
        return await createLogRecord(geofenceId, form: form);
      }

      // final entryDate = hasEntry?.enterDate?.add(const Duration(minutes: 30));
      // final hasEntryDate = hasEntry.enterDate != null;
      final hasExitDate = hasEntry.exitDate?.microsecond != null;

      // if has exit date and exit date is after now
      // exit date is 12: 30 + 30 minutes = 13:00
      // now DateTime .now() .isAfter(13:00)
      // create new record
      // else
      // update record

      if (hasExitDate) {
        // final exitDate = hasEntry.exitDate?.add(const Duration(minutes: 30));
        final entryExitDifference = DateTime.now().difference(hasEntry.exitDate!).inMinutes;
        // print('difference between enter and exit date is $entryExitDifference in minutes');

        // final canCreateNew = exitDate?.isAfter(DateTime.now().toLocal()) ?? false;
        if (entryExitDifference > 15) {
          // delete old record from storage
          // await storage.removeLogRecord(geofenceId);
          // create new record
          return await createLogRecord(geofenceId, form: form);
        } else {
          return ApiResult.failure(
            error: NetworkExceptions.defaultError(
              'user has entered $entryExitDifference minutes ago, no need to create new log record',
            ),
          );
        }
      }

      return const ApiResult.failure(
        error: NetworkExceptions.defaultError(
          'user has not exited from previous fence',
        ),
      );

      // else if (hasEntryDate) {
      //   return const ApiResult.failure(error: NetworkExceptions.defaultError('user is inside nothing to do here'));
      // } else {
      //   // create new record
      //   return await createLogRecord(geofenceId, form: form);
      // }
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<LogbookEntry>> udpateForm(String geofenceId, String form, {int? logId}) async {
    final logRecord = await getLogRecord(geofenceId);

    try {
      if (logId != null) {
        return _patchForm(geofenceId, form, logId);
      }

      if (logRecord != null) {
        return _patchForm(geofenceId, form, logRecord.id!);
      } else {
        final id = await getLogRecord(geofenceId);
        late ApiResult<LogbookEntry> result;
        if (id != null) {
          return _patchForm(geofenceId, form, id.id!);
        } else {
          final newLogRecord = await createLogRecord(geofenceId);
          newLogRecord.when(success: (logRecord) async {
            result = await _patchForm(geofenceId, form, logRecord.id!);
          }, failure: (e) {
            result = ApiResult.failure(error: NetworkExceptions.getDioException(e));
          });
        }
        return result;
      }
    } on DioError catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<LogbookEntry>> _patchForm(String geofenceId, String form, int logRecordId) async {
    try {
      final result = await client.patch(
        '${Endpoints.logRecords}/$logRecordId',
        data: {'form': form, 'geofenceID': geofenceId},
      );
      final logbookEntry = LogbookEntry.fromJson(Map<String, dynamic>.from(result.data['data']));
      _updateEntry(logbookEntry);
      await storage.saveLogRecord(geofenceId, logbookEntry);
      return ApiResult.success(data: logbookEntry);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<LogbookEntry?> getLogRecord(String geofenceId) async {
    if (_logRecords.isEmpty) {
      await _completer.future;
    }
    final userId = storageService.getUser()?.id;
    // _sortById();
    final record = _logRecords.where((element) => element.geofence?.id == int.parse(geofenceId));

    /// if user has more than one record for the same geofence

    if (kDebugMode) {
      print('records length: ${record.length}');
    }

    // records created by the current user for the geofence id
    final recordsByUser = record.where((element) => element.user?.id == userId);
    // final _records = (recordsByUser.toList());
    if (kDebugMode) {
      print('recordsByUser length: ${recordsByUser.length}');
    }

    // find the latest record

    // final latestRecord = recordsByUser.reduce((value, element) {
    //   if (value.enterDate!.isAfter(element.enterDate!)) {
    //     return value;
    //   } else {
    //     return element;
    //   }
    // });

    // print(latestRecord.id);

    final recordsPast15Minutes = recordsByUser.where((element) {
      if (element.form.isEmpty) {
        return DateTime.now().difference(element.enterDate!).inHours <= 24;
      }
      if (element.exitDate == null) {
        return true;
      }

      return DateTime.now().difference(element.enterDate!).inMinutes <= 30;
    });

    if (kDebugMode) {
      print('records in last 15 minutes: ${recordsPast15Minutes.length}');
    }
    if (recordsPast15Minutes.isNotEmpty) {
      // if (recordsPast15Minutes.first != currentLogRecordEntry) {
      //   currentLogRecordEntry = recordsPast15Minutes.first;
      // }
      return recordsPast15Minutes.first;
    } else {
      return null;
    }
    // return recordsPast15Minutes.isNotEmpty ? recordsPast15Minutes.first : currentLogRecordEntry;
  }

  void _updateEntry(LogbookEntry entry) {
    final index = _logRecords.indexWhere((element) => element.id == entry.id);
    if (index != -1) {
      final currentEntry = _logRecords.elementAt(index);
      currentEntry.exitDate = entry.exitDate;
      currentEntry.form = entry.form;
      currentEntry.enterDate = entry.enterDate;
    } else {
      _logRecords.add(entry);
    }
    _sortById();
  }

  void _sortById() => _logRecords.sort((a, b) => b.id!.compareTo(a.id!));

  @override
  Stream<List<LogbookEntry>> get logbookRecordsStream => storage.logbookRecordsStream;

  @override
  List<LogbookEntry> get logbookRecords => _logRecords;
}
