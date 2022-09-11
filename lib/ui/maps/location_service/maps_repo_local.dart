import 'dart:async';

// import 'package:location_repo/src/maps/src/storage_service.dart';

import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:background_location/ui/maps/location_service/storage_service.dart';
import 'package:rxdart/subjects.dart';

import '../models/polygon_model.dart';
import 'maps_repo.dart';

enum _MapsKeys {
  polygons,
}

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
      success: (data) {
        _controller.add(data);
      },
      failure: (f) {},
    );
    storage.polygonStream.listen((list) {
      _controller.add(list);
    });
  }

  @override
  Future<ApiResult<void>> savePolygon(PolygonModel model) async {
    try {
      await storage.savePolygon(model);
      // polygons.add(model.toJson());
      // await storage.put('polygons', polygons);
      return ApiResult.success(data: Null);
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
    // _controller.add([model]);
    // await _storageService.getAllPolygon();
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
          failure: (s) {});
      // final polygons = list.map((e) => PolygonModel.fromJson(e)).toList();
      // _controller.add(polygons);
      return ApiResult.success(data: _controller.value);
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  // @override
  // Future<ApiResult> notifyManager(String pic, String lat, String lng) {
  //   // TODO: implement notifyManager
  //   throw UnimplementedError();
  // }

  @override
  void cancel() {
    // TODO: implement cancel
  }

  @override
  Future<ApiResult> logBookEntry(String pic, String? form, String locationId) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult> updatePolygon(PolygonModel model) {
    // TODO: implement updatePolygon
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> notifyManager(String pic, String lat, String lng, String locationId) {
    // TODO: implement notifyManager
    throw UnimplementedError();
  }
}
