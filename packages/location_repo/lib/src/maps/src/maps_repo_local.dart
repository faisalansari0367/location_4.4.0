import 'dart:async';

import 'package:location_repo/src/maps/maps_repo.dart';
import 'package:location_repo/src/maps/src/storage_service.dart';

class MapsRepoLocal implements MapsRepo {
  late final StorageService _storageService;
  final _controller = StreamController<List<PolygonModel>>();

  MapsRepoLocal();

  @override
  Future<List<PolygonModel>> getAllPolygon() async {
    final list = await _storageService.getAllPolygon();
    // _controller.add(list);
    return list;
  }

  @override
  Future<void> init() async {
    _storageService = StorageService();
    await _storageService.init();
    final result = await getAllPolygon();
    _controller.add(result);
    _storageService.polygonStream.listen((list) {
      _controller.add(list);
    });
  }

  @override
  Future<void> savePolygon(PolygonModel model) async {
    await _storageService.savePolygon(model);
    // await _storageService.getAllPolygon();
  }

  @override
  Stream<List<PolygonModel>> get polygonStream => _controller.stream;
}
