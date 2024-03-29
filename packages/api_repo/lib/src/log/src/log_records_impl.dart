// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:api_client/api_client.dart';
import 'package:api_client/configs/client.dart';
import 'package:api_repo/src/auth/src/storage/storage_service.dart';
import 'package:api_repo/src/log/log_records.dart';
import 'package:api_repo/src/log/src/log_records_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LogRecordsImpl implements LogRecordsRepo {
  final Client client;
  final Box box;
  late LogRecordsLocalService storage;
  late StorageService storageService;

  final Completer<LogbookResponseModel> _completer =
      Completer<LogbookResponseModel>();

  // bool _isSyncing = false;

  // List<LogbookEntry> _logRecords = [];
  // LogbookEntry? currentLogRecordEntry;

  /// [LogRecordsImpl] constructor
  LogRecordsImpl({required this.client, required this.box}) {
    storageService = StorageService(box: box);
    storage = LogRecordsLocalService(box: box);
    // logbookRecordsStream.listen((event) => _logRecords = event);
    // _logRecords = storage.logRecords;
  }

  // int getDifference(DateTime? date) {
  //   if (date == null) return 0;
  //   final difference = DateTime.now().difference(date);
  //   return difference.inMinutes;
  // }

  @override
  Future<bool> synchronizeLogRecords() async {
    // map offline ids and online ids to identify them

    // fix time difference

    try {
      final offlineRecords = storage.offlineLogRecords.getOfflineLogRecords();
      log('offline records: ${offlineRecords.length}');
      if (offlineRecords.isEmpty) {
        log('no offline records to sync');
        return true;
      }

      final recordsToBeUpdated = <LogbookEntry>{};

      for (var offRecord in offlineRecords) {
        final offlineLog = logbookRecords.where(
          (element) {
            // record is present in the online and offline records
            // and it is not offline
            final elementExist =
                element.id == offRecord.id && !element.isOffline;
            final isIdentical = element.enterDate == offRecord.enterDate &&
                offRecord.geofence?.id == element.geofence?.id &&
                offRecord.user?.id == element.user?.id;
            
            final elementHasForm = element.form == offRecord.form;

            return elementExist || isIdentical;
          },
        );

        if (offlineLog.isNotEmpty) {
          recordsToBeUpdated.addAll(offlineLog);
        }
      }

      log('records to be updated: ${recordsToBeUpdated.length}');

      if (recordsToBeUpdated.isNotEmpty) {
        for (final entry in recordsToBeUpdated) {
          if (!entry.isOffline) {
            log('updating log record : ${entry.id}');
            final form = entry.form?.toJson() ?? {};

            if (entry.exitDate != null) {
              form['exitDate'] = entry.exitDate?.toUtc().toIso8601String();
            }

            final result = await _patchForm(form, entry.id!);
            result.when(success: (s) async {
              log('log record ${s.id} updated successfully');
              offlineRecords.removeWhere((element) => element.id == s.id);
              await storage.offlineLogRecords.remove(s);
            }, failure: (f) {
              log('log record ${entry.id} update failed');
            });
          }
        }
      }

      if (offlineRecords.isEmpty) {
        log('no offline records to sync');
        // _isSyncing = false;
        return true;
      }

      log('final offline records: ${offlineRecords.length}');
      final json = offlineRecords.map((e) {
        final map = e.toJson();
        map
          ..remove('id')
          ..remove('updatedAt')
          ..remove('isOffline');
        map['geofence'] = e.geofence?.id;
        return map;
      }).toList();

      // return true;

      final result = await client
          .post(Endpoints.logRecordsOffline, data: {'records': json});

      final isSuccess = result.data['status'] == 'success';
      if (isSuccess) {
        await storage.offlineLogRecords.clearOfflineRecords();
        await getLogbookRecords();
        log(
          'geofences synced successfully: offline Records ${storage.offlineLogRecords.logRecords.length}',
        );
      }
      // _isSyncing = false;
      return isSuccess;
      // return false;
      // return false;

      // return false;
    } catch (e) {
      // _isSyncing = false;
      rethrow;
    }
  }

  @override
  Future<ApiResult<LogbookEntry>> createLogRecord(String geofenceId,
      {LogbookFormModel? form}) async {
    try {
      final data2 = {'form': form, 'geofenceID': geofenceId};
      if (form == null) data2.remove('form');
      final result = await client.post(Endpoints.logRecords, data: data2);
      final map = Map<String, dynamic>.from(result.data['data']);
      final logbookEntry = LogbookEntry.fromJson(map);
      logbookRecords.insert(0, logbookEntry);
      storage.saveLogbookRecords(LogbookResponseModel(data: logbookRecords));
      log('logRecord ${logbookEntry.id} created');
      return ApiResult.success(data: logbookEntry);
    } on DioError catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<LogbookEntry>> markExit(String geofenceId) async {
    try {
      LogbookEntry? hasEntry = await getLogRecord(geofenceId);
      if (hasEntry == null) {
        return const ApiResult.failure(
            error: NetworkExceptions.defaultError('No log record found'));
      }
      final result = await client.patch('${Endpoints.markExit}/${hasEntry.id}');
      final logbookEntry =
          LogbookEntry.fromJson(Map<String, dynamic>.from(result.data['data']));
      _updateEntry(logbookEntry);
      return ApiResult.success(data: logbookEntry);
    } on DioError catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<LogbookResponseModel>> getLogbookRecords(
      {int page = 1, int limit = 20}) async {
    try {
      // if (!_completer.isCompleted) {
      //   return ApiResult.success(data: await _completer.future);
      // }
      // _completer = Completer<LogbookResponseModel>();
      final queryParameters = {'skip': 0, 'limit': 100};
      final result = await client.get(
        Endpoints.logRecords,
        queryParameters: queryParameters,
        logging: false,
      );
      final data = LogbookResponseModel.fromJson(result.data);
      data.data!.sort((a, b) => b.id!.compareTo(a.id!));
      await storage.saveLogbookRecords(data);
      if (!_completer.isCompleted) {
        _completer.complete(data);
      }
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<void> exitDateChecker() async {
    final LogRecordsHelper helper = LogRecordsHelper(
        storage: storage, userId: storageService.getUser()?.id);
    final isAdmin = storageService.getUser()?.role == 'Admin';
    if (!isAdmin) {
      final loggedInZones = logbookRecords
          .where(helper.isCreatedByUser)
          .where(helper.isLoggedInZone);
      if (loggedInZones.isEmpty) return;
      final lastEntry = loggedInZones.first;
      markExitById(lastEntry.id.toString());
    } else {
      final loggedInZones = logbookRecords.where(helper.isLoggedInZone);
      if (loggedInZones.isEmpty) return;
      final lastEntry = loggedInZones.first;
      markExitById(lastEntry.id.toString());
    }
  }

  @override
  Future<ApiResult<LogbookEntry>> logBookEntry(
    // String pic,
    String geofenceId, {
    bool isExiting = false,
    LogbookFormModel? form,
  }) async {
    try {
      // get the latest entry from the logRecords
      final hasEntry = await getLogRecord(geofenceId);

      // if no entry, create new entry
      if (hasEntry == null) {
        return await createLogRecord(geofenceId, form: form);
      }

      // if has entry
      final hasExitDate = hasEntry.exitDate?.microsecond != null;
      if (hasExitDate) {
        final entryExitDifference =
            DateTime.now().difference(hasEntry.exitDate!).inMinutes.abs();
        if (entryExitDifference > 30) {
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
          'log Record has no exit date',
        ),
      );
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<LogbookEntry>> udpateForm(
      String geofenceId, Map<String, dynamic> form,
      {int? logId}) async {
    final logRecord = await getLogRecord(geofenceId);

    try {
      if (logId != null) {
        return _patchForm(form, logId);
      }

      if (logRecord != null) {
        return _patchForm(form, logRecord.id!);
      } else {
        return const ApiResult.failure(
            error: NetworkExceptions.defaultError('no log record found'));
      }
    } on DioError catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<LogbookEntry>> _patchForm(
      Map<String, dynamic> form, int logRecordId) async {
    try {
      final form0 = <String, dynamic>{};
      form.forEach((key, value) {
        if (value != null) form0[key] = value;
      });

      // if (form['expectedDepartureTime'] == null) {
      //   form.remove('expectedDepartureTime');
      // }
      // if (form['additionalInfo'] == null) {
      //   form.remove('additionalInfo');
      // }
      final result = await client.patch(
        '${Endpoints.logRecords}/$logRecordId',
        // data: {'form': form, 'geofenceID': geofenceId},
        data: form0,
      );
      final data = Map<String, dynamic>.from(result.data['data']);
      final logbookEntry = LogbookEntry.fromJson(data);
      _updateEntry(logbookEntry);
      storage.saveLogbookRecords(LogbookResponseModel(data: logbookRecords));
      return ApiResult.success(data: logbookEntry);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<LogbookEntry?> getLogRecord(String geofenceId) async {
    if (logbookRecords.isEmpty) {
      await _completer.future;
    }

    final userId = storageService.getUser()?.id;
    // _sortById();

    /// records of this geofence
    final geofenceRecords = logbookRecords
        .where((element) => element.geofence?.id == int.parse(geofenceId));

    if (kDebugMode) {
      print('geofence $geofenceId records: ${geofenceRecords.length}');
    }

    // records created by the current user for this geofence
    final recordsByUser =
        geofenceRecords.where((element) => element.user?.id == userId);
    if (kDebugMode) {
      print('recordsByUser length: ${recordsByUser.length}');
    }

    // records created by the current user for this geofence in the last 15 minutes
    final recordsPast15Minutes = recordsByUser.where((element) {
      final difference = DateTime.now().difference(element.enterDate!);
      if (!(element.hasForm)) {
        return difference.inHours <= 24;
      }
      if (element.exitDate == null) return true;

      return difference.inMinutes <= 30;
    });

    if (kDebugMode) {
      print('records in last 15 minutes: ${recordsPast15Minutes.length}');
    }

    // get the latest record
    if (recordsPast15Minutes.isNotEmpty) {
      return recordsPast15Minutes.first;
    } else {
      return null;
    }
  }

  void _updateEntry(LogbookEntry entry) {
    final index =
        logbookRecords.indexWhere((element) => element.id == entry.id);
    if (index != -1) {
      final currentEntry = logbookRecords.elementAt(index);
      currentEntry.exitDate = entry.exitDate;
      currentEntry.form = entry.form;
      currentEntry.enterDate = entry.enterDate;
      logbookRecords[index] = currentEntry;
    } else {
      logbookRecords.add(entry);
    }
    _sortById();
  }

  void _sortById() => logbookRecords.sort((a, b) => b.id!.compareTo(a.id!));

  @override
  Stream<List<LogbookEntry>> get logbookRecordsStream =>
      storage.logbookRecordsStream;

  @override
  List<LogbookEntry> get logbookRecords => storage.logRecords.toSet().toList();
  // List<LogbookEntry> get logbookRecords => storage.logRecords;

  @override
  Future<ApiResult<LogbookEntry>> markExitById(String logRecordId) async {
    try {
      final result = await client.patch('${Endpoints.markExit}/$logRecordId');
      final logbookEntry =
          LogbookEntry.fromJson(Map<String, dynamic>.from(result.data['data']));
      _updateEntry(logbookEntry);
      return ApiResult.success(data: logbookEntry);
    } on DioError catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  /// this will be called when there is not exit date for the current log record
  /// and user is not in any geofence
  @override
  Future<void> previousZoneExitDateChecker() async {
    final userId = storageService.getUser()?.id;
    final records = logbookRecords;
    final recordsByUser =
        records.where((element) => element.user?.id == userId);
    if (recordsByUser.isNotEmpty) {
      final record = recordsByUser.first;
      record.exitDate = DateTime.now();
      final index =
          logbookRecords.indexWhere((element) => element.id == record.id);
      if (index == -1) return;
      logbookRecords[index] = record;
      await storage
          .saveLogbookRecords(LogbookResponseModel(data: logbookRecords));
      await storage.offlineLogRecords.update(record);
    }
  }
}
