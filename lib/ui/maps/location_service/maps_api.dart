// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/configs/client.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/maps/location_service/storage_service.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:rxdart/subjects.dart';

class _Endpoints {
  static const String geofences = '/geofences';
  static String geofence(String? id) => '/geofences/$id';

  // static const String notifyManager = '/notifyManager';
  static const String notifyProperyManager = '/users/notify-property-manager';
  // static const String registerEntryToLogbook = '/users/register-entry-to-logbook';
  static const String logRecords = '/log-records/';
}

class MapsApi implements MapsRepo {
  final Client client;
  late MapsStorageService storage;
  MapsApi({required this.client}) {
    // getAllPolygon();
  }

  // final _debouncer = CallbackDebouncer(1.seconds);

  Completer? completer;

  final _controller = BehaviorSubject<List<PolygonModel>>.seeded([]);

  @override
  Future<ApiResult<List<PolygonModel>>> getAllPolygon() async {
    try {
      // if (completer != null && !(completer?.isCompleted ?? true)) return ApiResult.success(data: _controller.value);
      // completer = Completer<void>();
      final result = await client.get(_Endpoints.geofences);
      final data = (result.data['data'] as List<dynamic>).map((e) => PolygonModel.fromJson(e)).toList();
      _controller.add(data);
      await storage.saveAllPolygon(data);
      // completer?.complete();
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
    // throw UnimplementedError();
  }

  @override
  Future<void> init() async {
    storage = MapsStorageService();
    await storage.init();
    await getAllPolygon();
    // polygonStream.listen((event) async {
    //   for (var item in event) {
    //     await storage.savePolygon(item);
    //   }
    // });
  }

  @override
  Stream<List<PolygonModel>> get polygonStream => _controller.stream;

  @override
  Future<ApiResult<void>> savePolygon(PolygonModel model) async {
    try {
      final data = model.toApiJson();
      final result = await client.post(_Endpoints.geofences, data: data);
      _controller.add([..._controller.value, model]);
      await getAllPolygon();

      return ApiResult.success(data: result.data);
    } on Exception catch (e) {
      print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<void>> updatePolygon(PolygonModel model) async {
    try {
      final data = model.toApiJson();
      final result = await client.patch(_Endpoints.geofence(model.id), data: data);
      final list = _controller.value;
      final index = list.indexWhere((element) => element.id == model.id);
      list[index] = model;
      _controller.add(list);
      await getAllPolygon();
      return ApiResult.success(data: result.data);
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<String>> notifyManager(
    String pic,
    String lat,
    String lng,
    String locationId,
  ) async {
    try {
      final result = await client.post(
        _Endpoints.notifyProperyManager,
        data: {
          // 'pic': pic,
          'latitude': lat,
          'longitude': lng,
          'geofenceID': locationId,
        },
      );
      // print(result);
      // _controller.add([..._controller.value, model]);
      // getAllPolygon();

      return ApiResult.success(data: result.data['data']);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> logBookEntry(String pic, String? form, String locationId, {bool isExiting = false}) async {
    try {
      // await storage.removeLogbookEntry(locationId);

      final hasEntry = storage.getLogbookEntry(locationId);
      if (hasEntry?.id != null) {
        // final entryDate = hasEntry?.enterDate?.add(const Duration(minutes: 30));
        final hasEntryDate = hasEntry?.enterDate != null;
        final hasExitDate = hasEntry?.exitDate?.microsecond != null;
        print(hasExitDate);
        // if has exit date and exit date is after now
        // exit date is 12: 30 + 30 minutes = 13:00
        // now DateTime .now() .isAfter(13:00)
        // create new record
        // else
        // update record

        if (hasExitDate) {
          final exitDate = hasEntry?.exitDate?.add(const Duration(minutes: 30));
          final canCreateNew = exitDate?.isAfter(DateTime.now()) ?? false;
          if (canCreateNew) {
            // delete old record from storage
            await storage.removeLogbookEntry(locationId);

            // create new record
            return await _createLogbookEntry(locationId, form);
          }
        } else if (hasEntryDate) {
          // if entry date is after now
          // entry date is 12: 30 + 30 minutes = 13:00
          // now DateTime.now().isAfter(13:00)
          // update exit time to now

          final entryDate = hasEntry?.enterDate!.add(const Duration(minutes: 30));
          final canUpdateExitTime = entryDate!.isAfter(DateTime.now());
          print(
            'can update exit time $canUpdateExitTime',
          );
          if (canUpdateExitTime) {
            print(canUpdateExitTime);
            await _updateLogbookEntry(hasEntry!.id!, locationId);
            // final result = await client.patch(
            //   '${_Endpoints.logRecords}$locationId',
            //   data: {
            //     'exitDate': DateTime.now().toIso8601String(),
            //   },
            // );
          }
        } else {
          // create new record
          await _createLogbookEntry(locationId, form);
        }

        /// user has entered again before 30 minutes
        // if (hasEntryDate && hasExitDate && entryDate?.isAfter(DateTime.now()) ?? false) {
        //   return ApiResult.failure(error: NetworkExceptions.custom('You have entered again before 30 minutes'));
        // }

        return ApiResult.success(data: Null);
      }

      // final data2 = {'form': form, 'geofenceID': locationId};
      // if (form == null) data2.remove('form');
      // final result = await client.post(_Endpoints.logRecords, data: data2);
      // final logbookEntry = LogbookEntry.fromJson(Map<String, dynamic>.from(result.data['data']));
      // await storage.saveLogbookEntry(locationId, logbookEntry);

      await _createLogbookEntry(locationId, form);
      return ApiResult.success(data: Null);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  // update logobook entry
  Future<void> _updateLogbookEntry(int logId, String geofenceId) async {
    final result = await client.patch('${_Endpoints.logRecords}$logId');
    final data = Map<String, dynamic>.from(result.data['data']);
    final logbookEntry = LogbookEntry.fromJson(data);
    await storage.saveLogbookEntry(geofenceId, logbookEntry);
  }

  Future<ApiResult<LogbookEntry>> updateForm(String geofenceId, String form) async {
    final logRecord = storage.getLogbookEntry(geofenceId);
    try {
      if (logRecord != null) {
        final result = await client.patch(
          '${_Endpoints.logRecords}${logRecord.id}',
          data: {'form': form},
        );
        final logbookEntry = LogbookEntry.fromJson(Map<String, dynamic>.from(result.data['data']));
        await storage.saveLogbookEntry(geofenceId, logbookEntry);
        return ApiResult.success(data: logbookEntry);
      } else {
        final result = await _createLogbookEntry(geofenceId, form);
        return result;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        return await _createLogbookEntry(geofenceId, form);
      }
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  /// create new logbook entry
  Future<ApiResult<LogbookEntry>> _createLogbookEntry(String locationId, String? form) async {
    try {
      final data2 = {'form': form, 'geofenceID': locationId};
      if (form == null) data2.remove('form');
      final result = await client.post(_Endpoints.logRecords, data: data2);
      final logbookEntry = LogbookEntry.fromJson(Map<String, dynamic>.from(result.data['data']));
      await storage.saveLogbookEntry(locationId, logbookEntry);
      return ApiResult.success(data: logbookEntry);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  void cancel() {
    _controller.add(<PolygonModel>[]);
  }

  @override
  Future<ApiResult> deletePolygon(PolygonModel model) async {
    try {
      final result = await client.delete(_Endpoints.geofence(model.id));
      await getAllPolygon();
      return ApiResult.success(data: result.data);
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<void> saveAllPolygon(List<PolygonModel> polygons) {
    return storage.saveAllPolygon(polygons);
  }

  // @override
  // Future<ApiResult> updateLocation(PolygonModel model) {
  //   throw UnimplementedError();
  // }
}
