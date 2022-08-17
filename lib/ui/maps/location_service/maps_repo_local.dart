import 'dart:async';

// import 'package:location_repo/src/maps/src/storage_service.dart';

import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:rxdart/subjects.dart';

import '../models/polygon_model.dart';
import 'maps_repo.dart';
import 'storage_service.dart';

class MapsRepoLocal implements MapsRepo {
  late final StorageService _storageService;
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
    _storageService = StorageService();
    await _storageService.init();
    final result = await getAllPolygon();
    result.when(
      success: (data) {
        _controller.add(data);
      },
      failure: (f) {},
    );
    _storageService.polygonStream.listen((list) {
      _controller.add(list);
    });
  }

  @override
  Future<void> savePolygon(PolygonModel model) async {
    await _storageService.savePolygon(model);
    // _controller.add([model]);
    // await _storageService.getAllPolygon();
  }

  @override
  Stream<List<PolygonModel>> get polygonStream => _controller.stream;

  @override
  Future<ApiResult<List<PolygonModel>>> getAllPolygon() async {
    try {
      final list = await _storageService.getAllPolygon();
      list.when(
        success: (data) {
          _controller.add(data);
        },
        failure: (e) {},
      );
      return ApiResult.success(data: _controller.value);
    } on Exception catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
