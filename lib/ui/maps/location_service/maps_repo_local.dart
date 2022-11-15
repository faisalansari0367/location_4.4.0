import 'dart:async';

// import 'package:location_repo/src/maps/src/storage_service.dart';

import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/src/user/src/models/logbook_entry_model.dart';
import 'package:background_location/ui/maps/location_service/storage_service.dart';
import 'package:rxdart/subjects.dart';

import '../models/polygon_model.dart';
import 'maps_repo.dart';

class MapsRepoLocal implements MapsRepo {
  late MapsStorageService storage;
  final _controller = BehaviorSubject<List<PolygonModel>>.seeded([]);
  static final MapsRepoLocal _singleton = MapsRepoLocal._internal();

  factory MapsRepoLocal() {
    return _singleton;
  }

  MapsRepoLocal._internal();

  // MapsRepoLocal();

  // @override
  // Future<List<PolygonModel>> getAllPolygon() async {
  //   final list = await _storageService.getAllPolygon();
  //   _controller.add(list);
  //   return list;
  // }

  @override
  Future<void> init() async {
    storage = MapsStorageService();
    await storage.init();
    final result = await getAllPolygon();
    result.when(
      success: _controller.add,
      failure: (f) {},
    );
    storage.polygonStream.listen(_controller.add);
  }

  @override
  Future<ApiResult<void>> savePolygon(PolygonModel model) async {
    try {
      // await storage.savePolygon(model);j b6
      final value = [..._controller.value, model];
      await storage.saveAllPolygon(value);
      _controller.add(value);
      return const ApiResult.success(data: Null);
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Stream<List<PolygonModel>> get polygonStream => _controller.stream;

  @override
  Future<ApiResult<List<PolygonModel>>> getAllPolygon() async {
    try {
      final list = await storage.getAllPolygon();
      list.when(
        success: (s) {
          _controller.add(s);
        },
        failure: (s) {},
      );
      return ApiResult.success(data: _controller.value);
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  // @override
  // Future<ApiResult> notifyManager(String pic, String lat, String lng) {
  //   throw UnimplementedError();
  // }

  @override
  void cancel() => _controller.add([]);

  @override
  Future<ApiResult> logBookEntry(String pic, String? form, String locationId, {bool isExiting = false}) async {
    return const ApiResult.failure(error: NetworkExceptions.defaultError('unimplemented'));
  }

  @override
  Future<ApiResult> updatePolygon(PolygonModel model) async {
    final list = _controller.value;
    final index = list.indexWhere((element) => element.id == model.id);
    list[index] = model;
    _controller.add(list);
    return const ApiResult.success(data: Null);
  }

  @override
  Future<ApiResult<String>> notifyManager(String pic, String lat, String lng, String locationId) async {
    return const ApiResult.success(data: 'No internet connection');
  }

  @override
  Future<ApiResult> deletePolygon(PolygonModel model) async {
    final value = [..._controller.value];
    value.remove(model);
    _controller.add(value);
    return const ApiResult.success(data: Null);
  }

  @override
  Future<void> saveAllPolygon(List<PolygonModel> polygons) {
    return storage.saveAllPolygon(polygons);
  }

  @override
  Future<ApiResult<LogbookEntry>> updateForm(String geofenceId, String form) {
    return storage.updateForm(geofenceId, form);
  }

  @override
  bool get hasPolygons => _controller.value.isNotEmpty;
  
  @override
  // TODO: implement polygonsCompleter
  Future<List<PolygonModel>> get polygonsCompleter => storage.getAllPolygon().then((value) => value.when(success: (s) => s, failure: (f) => []));
}
