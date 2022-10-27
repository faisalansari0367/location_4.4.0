import 'dart:developer';

import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/configs/client.dart';
import 'package:api_repo/src/auth/src/storage/storage_service.dart';
import 'package:api_repo/src/log/log_records.dart';
import 'package:api_repo/src/user/src/models/logbook_entry_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../configs/endpoint.dart';

class LogRecordsImpl implements LogRecordsRepo {
  final Client client;
  final Box box;
  late LogRecordsLocalService storage;
  late StorageService storageService;
  LogRecordsImpl({required this.client, required this.box}) {
    storageService = StorageService(box: box);
    storage = LogRecordsLocalService(box: box);
    getLogbookRecords();
    logbookRecordsStream.listen((event) {
      _logRecords = event.toSet();
    });
  }

  Set<LogbookEntry> _logRecords = {};

  @override
  Future<ApiResult<LogbookEntry>> createLogRecord(String geofenceId, {String? form}) async {
    try {
      final data2 = {'form': form, 'geofenceID': geofenceId};
      if (form == null) data2.remove('form');
      final result = await client.post(Endpoints.logRecords, data: data2);
      final logbookEntry = LogbookEntry.fromJson(Map<String, dynamic>.from(result.data['data']));
      await storage.saveLogRecord(geofenceId, logbookEntry);
      getLogbookRecords();
      log('logRecord ${logbookEntry.id} created');
      return ApiResult.success(data: logbookEntry);
    } on DioError catch (e) {
      final data = e.response?.data['data'] ?? {};
      if (data?.containsKey('logRecord')) {
        // return ApiResult.failure(message: data['logRecord']);
        if (data != null) {
          return _updateLogRecord(data['logRecord'], geofenceId, form: form);
        }
      }
      // ['logRecord'];
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<LogbookEntry>> markExit(String geofenceId) async {
    try {
      LogbookEntry? hasEntry = storage.getLogRecord(geofenceId);
      hasEntry ??= getLogRecord(geofenceId);
      final result = await client.patch('${Endpoints.markExit}/${hasEntry!.id}');
      final logbookEntry = LogbookEntry.fromJson(Map<String, dynamic>.from(result.data['data']));
      // _logRecords.add(logbookEntry);
      getLogbookRecords();
      // await storage.saveLogRecord(geofenceId, logbookEntry);
      return ApiResult.success(data: logbookEntry);
    } on DioError catch (e) {
      final data = e.response?.data as Map;

      switch (data['message']) {
        case 'Log Record does not exist':
          final hasEntry = getLogRecord(geofenceId);
          if (hasEntry == null) return ApiResult.failure(error: NetworkExceptions.getDioException(e));
          final result = await client.patch('${Endpoints.markExit}/${hasEntry.id}');
          final logbookEntry = LogbookEntry.fromJson(Map<String, dynamic>.from(result.data['data']));
          await storage.saveLogRecord(geofenceId, logbookEntry);
          return ApiResult.success(data: logbookEntry);
        default:
      }

      if (data['message'] != null) {
        final isExited = data['message'] == "You already exited this geofence";
        if (isExited) {
          final getLatestRecord = getLogRecord(geofenceId);
          if (getLatestRecord != null) {
            final result = await client.patch('${Endpoints.markExit}/${getLatestRecord.id}');
            final logbookEntry = LogbookEntry.fromJson(Map<String, dynamic>.from(result.data['data']));
            await storage.saveLogRecord(geofenceId, logbookEntry);
            return ApiResult.success(data: logbookEntry);
          } else {
            return ApiResult.failure(error: NetworkExceptions.getDioException(e));
          }
        }
      }

      if (data == null) return ApiResult.failure(error: NetworkExceptions.getDioException(e));
      if (!data.containsKey('data')) {
        return ApiResult.failure(error: NetworkExceptions.getDioException(e));
      }

      // if (data != null) {
      //   return updateLogRecord(data, geofenceId);
      // }
      if (data.containsKey('logRecord')) {
        // return ApiResult.failure(message: data['logRecord']);
        return _updateLogRecord(data['logRecord'], geofenceId);
      }
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<LogbookResponseModel>> getLogbookRecords() async {
    try {
      final result = await client.get(Endpoints.logRecords);
      final data = LogbookResponseModel.fromJson(result.data);
      storage.saveLogbookRecords(data);
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<LogbookEntry>> _updateLogRecord(int logId, String geofenceId, {String? form}) async {
    try {
      final data = {'geofenceID': geofenceId};
      if (form != null) data['form'] = form;
      final result = await client.patch('${Endpoints.logRecords}/$logId', data: data);
      final json = Map<String, dynamic>.from(result.data['data']);
      final logbookEntry = LogbookEntry.fromJson(json);
      storage.updateLogRecord(geofenceId, logbookEntry);
      return ApiResult.success(data: logbookEntry);
    } on DioError catch (e) {
      final response = e.response?.data as Map;
      if (response['message'] == "Log Record does not exist") {
        return createLogRecord(geofenceId, form: form);
      }

      if (response['message'] == "You already exited this geofence") {
        final entry = getLogRecord(geofenceId);
        if (entry != null) {
          // return _updateLogRecord(entry.id!, geofenceId);
        }
      }
      final hasData = response.containsKey(['data']);
      if (!hasData) return ApiResult.failure(error: NetworkExceptions.getDioException(e));
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<LogbookEntry>> logBookEntry(
    String pic,
    String geofenceId, {
    bool isExiting = false,
    String? form,
  }) async {
    try {
      // await storage.removeLogbookEntry(locationId);

      final hasEntry = storage.getLogRecord(geofenceId);
      // final difference = DateTime.now().difference(hasEntry?.enterDate ?? DateTime.now()).inMinutes;
      // final difference = hasEntry?.enterDate?.difference(DateTime.now()).inMinutes;
      // log('time difference is $difference');

      if (hasEntry == null) {
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
        if (entryExitDifference > 30) {
          // delete old record from storage
          await storage.removeLogRecord(geofenceId);
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
  Future<ApiResult<LogbookEntry>> udpateForm(String geofenceId, String form, {int? logRecordId}) async {
    final logRecord = storage.getLogRecord(geofenceId);

    try {
      if (logRecord != null) {
        return _patchForm(geofenceId, form, logRecord.id!);
        // final result = await client.patch(
        //   '${Endpoints.logRecords}/${logRecord.id}',
        //   data: {'form': form, 'geofenceID': geofenceId},
        // );
        // final logbookEntry = LogbookEntry.fromJson(Map<String, dynamic>.from(result.data['data']));
        // await storage.saveLogRecord(geofenceId, logbookEntry);
        // return ApiResult.success(data: logbookEntry);
      } else {
        final id = getLogRecord(geofenceId);
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
        // final result = await client.patch(
        //   '${Endpoints.logRecords}/${logRecordId ?? id?.id}',
        //   data: {'form': form, 'geofenceID': geofenceId},
        // );
        // final logbookEntry = LogbookEntry.fromJson(Map<String, dynamic>.from(result.data['data']));
        // await storage.saveLogRecord(geofenceId, logbookEntry);
        // return ApiResult.success(data: logbookEntry);
      }
    } on DioError catch (e) {
      // final data = e.response?.data as Map;
      // if (data.containsKey('message')) {
      //   if (data['message'] == 'Log Record does not exist') {
      //     final logRecord = getLogRecord(geofenceId)?.id;
      //     if (logRecord != null) {
      //       return udpateForm(geofenceId, form, logRecordId: logRecord);
      //     }
      //     // return ApiResult.failure(error: NetworkExceptions.getDioException(e));
      //   }
      // }
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
      await storage.saveLogRecord(geofenceId, logbookEntry);
      return ApiResult.success(data: logbookEntry);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Stream<List<LogbookEntry>> get logbookRecordsStream => storage.logbookRecordsStream;

  @override
  LogbookEntry? getLogRecord(String geofenceId) {
    final userId = storageService.getUser()?.id;
    final record = _logRecords.where((element) => element.geofence?.id == int.parse(geofenceId));
    final recordsByUser = record.where((element) => element.user?.id == userId);
    return record.isNotEmpty ? recordsByUser.first : null;
  }
}


// Geofence a 
// entry date 


// geofence b


