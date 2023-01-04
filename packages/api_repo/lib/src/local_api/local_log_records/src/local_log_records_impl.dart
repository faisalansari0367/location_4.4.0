// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer' show log;
import 'dart:math' show Random;

import 'package:api_repo/api_repo.dart';
import 'package:api_repo/src/auth/src/storage/storage_service.dart';
import 'package:api_repo/src/geofences/src/storage/maps_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';


class LocalLogRecordsImpl extends LogRecordsRepo {
  LocalLogRecordsImpl({
    required this.box,
  }) {
    _init();
  }

  final Box box;

  late MapsStorageService _mapsStorageService;
  late LogRecordsLocalService _logRecordsLocalService;
  late StorageService _storageService;
  final _completer = Completer<void>();

  Future<void> _init() async {
    // geofences = await Hive.openBox('geofences');
    _logRecordsLocalService = LogRecordsLocalService(box: box);
    _mapsStorageService = MapsStorageService();
    _storageService = StorageService(box: box);
    await _mapsStorageService.init();
  }

  @override
  Future<bool> synchronizeLogRecords() async => false;

  List<LogbookEntry> get _logRecords => _logRecordsLocalService.logRecords;
  Stream<List<LogbookEntry>> get logRecordsToSync => _logRecordsLocalService.offlineLogRecords.logbookRecordsStream;

  @override
  Future<ApiResult<LogbookEntry>> createLogRecord(String geofenceId, {String? form}) async {
    // final geofence = _logRecordsLocalService.getLogRecord(geofenceId);
    try {
      final geofences = await _mapsStorageService.polygonsCompleter;
      final index = geofences.indexWhere((element) => element.id == geofenceId);

      if (index == -1) {
        return const ApiResult.failure(error: NetworkExceptions.defaultError('Geofence not found'));
      }

      final geofence = geofences[index];
      final _id = _logRecords.isEmpty ? 0 : _logRecords.first.id ?? 0;
      await exitFromPreviousZone();
      // await _logRecordsLocalService.offlineLogRecords.clearOfflineRecords();

      final LogbookEntry logRecord = LogbookEntry(
        form: null,
        // id: (_logRecords.first.id ?? 0) + 1,
        isOffline: true,
        id: Random().nextInt(10000000) + _id,
        createdAt: currentUtcTime,
        enterDate: currentUtcTime,
        user: _storageService.getUserData(),
        geofence: Geofence(
          id: int.parse(geofenceId),
          name: geofence.name,
          color: geofence.color,
          companyOwner: geofence.companyOwner,
          createdAt: geofence.createdAt?.toIso8601String(),
          pic: geofence.pic,
          points: Points(
            coordinates: geofence.points.map((e) => [e.latitude, e.longitude]).toList(),
            type: 'Polygon',
          ),
        ),
      );
      final records = _logRecordsLocalService.logRecords;
      records.insert(0, logRecord);
      final responseModel = LogbookResponseModel(data: records);
      await _logRecordsLocalService.offlineLogRecords.addOfflineRecord(logRecord);
      await _logRecordsLocalService.saveLogbookRecords(responseModel);
      log('logRecord created: ${logRecord.toJson()}');
      return ApiResult.success(data: logRecord);
    } catch (e) {
      log(e.toString());
      return const ApiResult.failure(error: NetworkExceptions.defaultError('No polygons found'));
    }
  }

  Future<void> exitFromPreviousZone() async {
    final userId = _storageService.getUser()?.id;
    final records = _logRecordsLocalService.logRecords;
    final recordsByUser = records.where((element) => element.user?.id == userId);
    final recordsPast15Minutes = recordsByUser.where((element) {
      if (element.exitDate == null) {
        return true;
      }

      return DateTime.now().difference(element.enterDate!).inMinutes <= 30;
    });

    if (recordsPast15Minutes.isNotEmpty) {
      final record = recordsPast15Minutes.first;
      record.exitDate = currentUtcTime;
      final index = logbookRecords.indexWhere((element) => element.id == record.id);
      if (index == -1) return;
      logbookRecords[index] = record;
      await _logRecordsLocalService.saveLogbookRecords(LogbookResponseModel(data: logbookRecords));
      await _logRecordsLocalService.offlineLogRecords.update(record);
    }
  }

  @override
  Future<LogbookEntry?> getLogRecord(String geofenceId) async {
    if (_logRecords.isEmpty) {
      // await _completer.future;
      return null;
    }

    final userId = _storageService.getUser()?.id;
    // _sortById();

    /// records of this geofence
    final geofenceRecords = _logRecords.where((element) => element.geofence?.id == int.parse(geofenceId));

    if (kDebugMode) {
      print('geofence $geofenceId records: ${geofenceRecords.length}');
    }

    // records created by the current user for this geofence
    final recordsByUser = geofenceRecords.where((element) => element.user?.id == userId);
    if (kDebugMode) {
      print('recordsByUser length: ${recordsByUser.length}');
    }

    // records created by the current user for this geofence in the last 15 minutes
    final recordsPast15Minutes = recordsByUser.where((element) {
      if (element.form?.isEmpty ?? true) {
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

    // get the latest record
    if (recordsPast15Minutes.isNotEmpty) {
      return recordsPast15Minutes.first;
    } else {
      return null;
    }
  }

  @override
  Future<ApiResult<LogbookResponseModel>> getLogbookRecords({int page = 1, int limit = 100}) async {
    final records = _logRecordsLocalService.getLogbookRecords();
    if (!_completer.isCompleted) {
      _completer.complete();
    }
    return records;
  }

  @override
  Future<ApiResult<LogbookEntry>> logBookEntry(String geofenceId,
      {bool isExiting = false, String? form}) async {
    try {
      // get the latest entry from the logRecords
      final hasEntry = await getLogRecord(geofenceId);

      // if no entry create new entry
      if (hasEntry == null) {
        return await createLogRecord(geofenceId, form: form);
      }

      // if has entry
      final hasExitDate = hasEntry.exitDate?.microsecond != null;
      if (hasExitDate) {
        final entryExitDifference = DateTime.now().difference(hasEntry.exitDate!).inMinutes.abs();
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
  List<LogbookEntry> get logbookRecords => _logRecords;

  @override
  Stream<List<LogbookEntry>> get logbookRecordsStream => _logRecordsLocalService.logbookRecordsStream;

  @override
  Future<ApiResult<LogbookEntry>> markExit(String geofenceId) async {
    try {
      LogbookEntry? hasEntry = await getLogRecord(geofenceId);
      if (hasEntry == null) {
        return const ApiResult.failure(error: NetworkExceptions.defaultError('No log record found'));
      }
      hasEntry.exitDate = currentUtcTime.subtract(const Duration(seconds: 20));
      final index = _logRecords.indexWhere((element) => element.id == hasEntry.id);
      if (index == -1) {
        return const ApiResult.failure(error: NetworkExceptions.defaultError('No log record found'));
      }
      _logRecords[index] = hasEntry;
      await _logRecordsLocalService.saveLogbookRecords(LogbookResponseModel(data: _logRecords));
      _logRecordsLocalService.offlineLogRecords.update(hasEntry);
      return ApiResult.success(data: hasEntry);
    } catch (e) {
      return const ApiResult.failure(error: NetworkExceptions.defaultError('error marking exit'));
    }
  }

  @override
  Future<ApiResult<LogbookEntry>> markExitById(String logRecordId) async {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<LogbookEntry>> udpateForm(String geofenceId, Map<String, dynamic> form, {int? logId}) async {
    try {
      if (logId != null) {
        return await _patchForm(logId, form);
      } else {
        final logRecord = await getLogRecord(geofenceId);
        if (logRecord == null) { 
          return const ApiResult.failure(error: NetworkExceptions.defaultError('no log record found'));
        }
        return await _patchForm(logRecord.id!, form);
      }
    } catch (e) {
      if (kDebugMode) {
        print('error updating form: $e');
      }
      return const ApiResult.failure(error: NetworkExceptions.defaultError('error updating form'));
    }
  }

  Future<ApiResult<LogbookEntry>> _patchForm(int logRecordId, Map<String, dynamic> formData) async {
    final index = _logRecords.indexWhere((element) => element.id == logRecordId);
    if (index != -1) {
      final form = LogbookFormModel.fromJson(formData);
      final logRecord = _logRecords[index];
      logRecord.form = form;
      // logRecord.updatedAt = currentUtcTime.toUtc();
      // save the updated form in the local database
      await _logRecordsLocalService.saveLogbookRecords(LogbookResponseModel(data: _logRecords));
      // update the form in the offline log records
      await _logRecordsLocalService.offlineLogRecords.update(logRecord);

      return ApiResult.success(data: logRecord);
    } else {
      return const ApiResult.failure(error: NetworkExceptions.defaultError('log record not found'));
    }
  }

  DateTime get currentUtcTime => DateTime.now();
}
