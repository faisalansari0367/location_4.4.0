import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location_repo/src/maps/maps_repo.dart';

class _Keys {
  static const _getAllPolygonKey = 'get_all_polygon';
  // static const id = 'get_all_polygon';
}

class StorageService implements MapsRepo {
  late final Box _box;
  @override
  @override
  Future<List<PolygonModel>> getAllPolygon() async {
    final map = _box.get(_Keys._getAllPolygonKey);
    print('all polygon data: $map');
    if (map == null) return <PolygonModel>[];
    final data = (map as List<dynamic>).map((e) => PolygonModel.fromJson(Map<String, dynamic>.from(e))).toList();
    return data;
  }

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox('location');
    _box = box;
  }

  @override
  Future<void> savePolygon(PolygonModel model) async {
    final list = await getAllPolygon();
    list.add(model);
    // await _box.put(model.id, model.toJson());
    final data = list.map((e) => e.toJson()).toList();
    await _box.put(_Keys._getAllPolygonKey, data);
  }

  @override
  Stream<List<PolygonModel>> get polygonStream => _box.watch(key: _Keys._getAllPolygonKey).map((map) {
        final data = (map as List<dynamic>).map((e) => PolygonModel.fromJson(Map<String, dynamic>.from(e))).toList();
        return data;
      });
}
