import 'dart:async';

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
  static const String notifyProperyManager = '/users/notify-property-manager';
}

class MapsApi implements MapsRepo {
  final Client client;
  late MapsStorageService storage;
  MapsApi({required this.client}) {}

  var completer = Completer<List<PolygonModel>>();

  final _controller = BehaviorSubject<List<PolygonModel>>.seeded([]);

  @override
  Future<ApiResult<List<PolygonModel>>> getAllPolygon() async {
    try {
      completer = Completer<List<PolygonModel>>();
      final result = await client.get(_Endpoints.geofences);
      final data = (result.data['data'] as List<dynamic>).map((e) => PolygonModel.fromJson(e)).toList();
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
  Future<void> init() async {
    storage = MapsStorageService();
    await storage.init();
    // await getAllPolygon();
  }

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
  Future<ApiResult<String>> notifyManager(String pic, String lat, String lng, String locationId) async {
    try {
      final result = await client.post(
        _Endpoints.notifyProperyManager,
        data: {'latitude': lat, 'longitude': lng, 'geofenceID': locationId},
      );
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

  @override
  bool get hasPolygons => _controller.value.isNotEmpty;

  @override
  Future<List<PolygonModel>> get polygonsCompleter => completer.future;
}
