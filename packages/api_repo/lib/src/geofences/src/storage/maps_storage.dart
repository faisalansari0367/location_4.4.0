import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:api_repo/src/geofences/geofences_repo.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rxdart/subjects.dart';

class _Keys {
  static const _getAllPolygonKey = 'get_all_polygon';
  // static const _getAllPolygonKey = 'get_all_polygon';

  // static const id = 'get_all_polygon';
}

class MapsStorageService implements GeofencesRepo {
  late final Box _box;

  // static const String _boxKey = 'location';

  final _controller = BehaviorSubject.seeded(<PolygonModel>[]);

  MapsStorageService({required Box box}) {
    _box = box;
    initGeofences();

    _listen();
  }

  @override
  Future<ApiResult<List<PolygonModel>>> getAllPolygon() async {
    final map = _box.get(_Keys._getAllPolygonKey);
    if (map == null) return const ApiResult.success(data: <PolygonModel>[]);
    final data = (map as List<dynamic>)
        .map(
          (e) => PolygonModel.fromLocalJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();
    _controller.add(data);
    return ApiResult.success(data: data);
  }

  final _completer = Completer<List<PolygonModel>>();

  Future<void> initGeofences() async {
    // final box = await Hive.openBox(_boxKey);
    // _box = box;
    if (_completer.isCompleted) return;
    final list = await getAllPolygon();
    list.when(
      success: (list) {
        if (_completer.isCompleted) return;
        _completer.complete(list);
      },
      failure: (failure) {
        _completer.completeError(failure);
      },
    );
    // _completer.complete();
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
    return const ApiResult.success(data: null);
    // await _box.put(model.id, model.toJson());
  }

  @override
  Stream<List<PolygonModel>> get polygonStream {
    return _controller.stream;
    // return _box.watch(key: _Keys._getAllPolygonKey).map(
    //   (event) {
    //     final data = (event.value as List<dynamic>)
    //         .map((e) => PolygonModel.fromLocalJson(Map<String, dynamic>.from(e)))
    //         .toList();
    //     return data;
    //   },
    // );
  }

  @override
  void cancel() {}

  @override
  Future<ApiResult> updatePolygon(PolygonModel model) async {
    final list = await getAllPolygon();
    await list.when(
      success: (list) async {
        final index = list.indexWhere((element) => element.id == model.id);
        if (index == -1) return;
        list[index] = model;
        await saveAllPolygon(list);
      },
      failure: (failure) {},
    );
    return const ApiResult.success(data: null);
  }

  @override
  Future<ApiResult<String>> notifyManager(String lat, String lng, String locationId) async {
    return const ApiResult.failure(
      error: NetworkExceptions.defaultError(
        'Not available in offline mode',
      ),
    );
  }

  @override
  Future<ApiResult> deletePolygon(PolygonModel model) async {
    final list = await getAllPolygon();
    await list.when(
      success: (list) async {
        final index = list.indexWhere((element) => element.id == model.id);
        if (index == -1) return;
        list.removeAt(index);
        await saveAllPolygon(list);
      },
      failure: (failure) {},
    );
    return const ApiResult.success(data: null);
  }

  @override
  Future<void> saveAllPolygon(List<PolygonModel> polygons) async {
    final json = polygons.map((e) => e.toJson()).toList();
    await _box.put(_Keys._getAllPolygonKey, json);
  }

  @override
  bool get hasPolygons => _box.get(_Keys._getAllPolygonKey) != null;

  @override
  Future<List<PolygonModel>> get polygonsCompleter => _completer.future;

  void _listen() {
    _box.watch(key: _Keys._getAllPolygonKey).map(
      (event) {
        final data = (event.value as List<dynamic>)
            .map((e) => PolygonModel.fromLocalJson(Map<String, dynamic>.from(e)))
            .toList();
        _controller.add(data);
        return data;
      },
    );
  }
}
