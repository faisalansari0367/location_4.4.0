import 'package:api_repo/api_repo.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/polygon_model.dart';
import 'maps_repo.dart';

class _Keys {
  static const _getAllPolygonKey = 'get_all_polygon';
  // static const _getAllPolygonKey = 'get_all_polygon';

  // static const id = 'get_all_polygon';
}

class MapsStorageService implements MapsRepo {
  late final Box _box;
  @override
  Future<ApiResult<List<PolygonModel>>> getAllPolygon() async {
    final map = _box.get(_Keys._getAllPolygonKey);
    // print('all polygon data: $map');
    if (map == null) return const ApiResult.success(data: <PolygonModel>[]);
    final data = (map as List<dynamic>).map((e) => PolygonModel.fromLocalJson(Map<String, dynamic>.from(e))).toList();
    return ApiResult.success(data: data);
  }

  @override
  Future<void> init() async {
    // await Hive.initFlutter();
    final box = await Hive.openBox('location');
    _box = box;
  }

  @override
  Future<ApiResult<void>> savePolygon(PolygonModel model) async {
    final list = await getAllPolygon();
    await list.when(
      success: (list) async {
        // list.add(data);
        final data = list.map((e) => e.toJson()).toList();
        await _box.put(_Keys._getAllPolygonKey, [...data, model.toJson()]);
      },
      failure: (failure) {},
    );
    return const ApiResult.success(data: Null);
    // await _box.put(model.id, model.toJson());
  }

  LogbookEntry? getLogbookEntry(String locationId) {
    final map = _box.get(locationId);
    if (map == null) return null;
    final entrylogBook = LogbookEntry.fromJson(Map<String, dynamic>.from(map));
    return entrylogBook;
  }

  Future<void> saveLogbookEntry(String locationId, LogbookEntry logbookEntry) async {
    return await _box.put(
      locationId,
      logbookEntry.toJson(),
    );
  }

  Future<void> removeLogbookEntry(String locationId) async {
    await _box.delete(locationId);
  }

  @override
  Stream<List<PolygonModel>> get polygonStream => _box.watch(key: _Keys._getAllPolygonKey).map((event) {
        final data = (event.value as List<dynamic>)
            .map((e) => PolygonModel.fromLocalJson(Map<String, dynamic>.from(e)))
            .toList();
        return data;
      });

  // @override
  // Future<ApiResult> notifyManager(String pic, String lat, String lng) async {
  //   return ApiResult.success(data: Null);
  // }

  @override
  void cancel() {}

  @override
  Future<ApiResult> logBookEntry(String pic, String? form, String locationId, {bool isExiting = false}) async {
    return const ApiResult.success(data: Null);
  }

  @override
  Future<ApiResult> updatePolygon(PolygonModel model) async {
    return const ApiResult.success(data: Null);
  }

  @override
  Future<ApiResult<String>> notifyManager(String lat, String lng, String locationId) async {
    return const ApiResult.success(data: 'Not available in offline mode');
  }

  @override
  Future<ApiResult> deletePolygon(PolygonModel model) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveAllPolygon(List<PolygonModel> polygons) async {
    final json = polygons.map((e) => e.toJson()).toList();
    await _box.put(_Keys._getAllPolygonKey, json);
  }

  @override
  Future<ApiResult<LogbookEntry>> updateForm(String geofenceId, String form) async {
    // final entry = getLogbookEntry(geofenceId);
    // if (entry != null) {
    //   entry.form = jsonDecode(form).map((field) => LogbookFormField.fromJson(field)).toList();
    //   return _box.put(geofenceId, entry.toJson()).then((value) => ApiResult.success(data: entry));
    // } else {
    return ApiResult.failure(
      error: NetworkExceptions.defaultError(
        'Entry not found',
      ),
    );
    // }
  }

  @override
  bool get hasPolygons => _box.get(_Keys._getAllPolygonKey) != null;

  @override
  // TODO: implement polygonsCompleter
  Future<List<PolygonModel>> get polygonsCompleter => throw UnimplementedError();
}
