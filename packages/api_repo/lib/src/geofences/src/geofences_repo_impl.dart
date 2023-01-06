// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:api_repo/api_repo.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rxdart/rxdart.dart';

import 'storage/maps_storage.dart';

class GeofencesRepoImpl implements GeofencesRepo {
  GeofencesRepoImpl({
    required this.client,
    required this.box,
  }) {
    // init();
    storage = MapsStorageService(box: box);
    // storage.initGeofences();
  }

  final Client client;
  final Box box;
  late MapsStorageService storage;

  Completer<List<PolygonModel>> completer = Completer<List<PolygonModel>>();

  final _controller = BehaviorSubject<List<PolygonModel>>.seeded([]);

  @override
  Future<ApiResult<List<PolygonModel>>> getAllPolygon() async {
    try {
      completer = Completer<List<PolygonModel>>();
      final result = await client.get(Endpoints.geofences, logging: false);
      final list = result.data['data'] as List<dynamic>;
      final data = list.map((e) => PolygonModel.fromJson(e)).toList();
      _controller.add(data);
      await storage.saveAllPolygon(data);
      if (!completer.isCompleted) {
        completer.complete(data);
      }
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<UserData>> temporaryOwner(TemporaryOwnerParams params) async {
    try {
      final result = await client.post(Endpoints.delegation, data: params.toJson());
      final data = result.data['data'];
      final userData = UserData.fromJson(data);
      return ApiResult.success(data: userData);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<bool>> removeTemporaryOwner(TemporaryOwnerParams params) async {
    try {
      final result = await client.post(Endpoints.removeDelegation, data: params.removeDelegation());
      final data = result.data['data'];
      return const ApiResult.success(data: true);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  // @override
  // Future<void> initGeofences() async {
  //   storage = MapsStorageService(box: box);
  // }

  @override
  Stream<List<PolygonModel>> get polygonStream => _controller.stream.map((event) => event
    ..sort(
      (a, b) => a.name.toLowerCase().compareTo(
            b.name.toLowerCase(),
          ),
    ));

  @override
  Future<ApiResult<void>> savePolygon(PolygonModel model) async {
    try {
      final data = model.toApiJson();
      await client.post(Endpoints.geofences, data: data);
      _controller.add([..._controller.value, model]);
      await getAllPolygon();
      return const ApiResult.success(data: null);
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<void>> updatePolygon(PolygonModel model) async {
    try {
      final data = model.toApiJson();
      final result = await client.patch(Endpoints.geofence(model.id), data: data);
      final list = _controller.value;
      final index = list.indexWhere((element) => element.id == model.id);
      list[index] = model;
      _controller.add(list);
      await getAllPolygon();
      return const ApiResult.success(data: null);
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<String>> notifyManager(String lat, String lng, String locationId) async {
    try {
      final data = {'latitude': lat, 'longitude': lng, 'geofenceID': locationId};
      final result = await client.post(Endpoints.notifyProperyManager, data: data);
      return ApiResult.success(data: result.data['data']);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  void cancel() => _controller.add(<PolygonModel>[]);

  @override
  Future<ApiResult> deletePolygon(PolygonModel model) async {
    try {
      final result = await client.delete(Endpoints.geofence(model.id));
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

  @override
  bool get hasPolygons => _controller.value.isNotEmpty;

  @override
  Future<List<PolygonModel>> get polygonsCompleter => completer.future;

  @override
  List<PolygonModel> get polygons => _controller.value;
}
