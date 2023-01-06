import 'package:api_client/api_result/api_result.dart';
import 'package:api_repo/src/auth/src/models/user_data.dart';
import 'package:api_repo/src/geofences/geofences_repo.dart';
import 'package:api_repo/src/geofences/src/storage/maps_storage.dart';
import 'package:hive_flutter/adapters.dart';

class GeofencesRepoLocalImpl implements GeofencesRepo {
  late MapsStorageService storage;
  GeofencesRepoLocalImpl({required Box box}) {
    storage = MapsStorageService(box: box);
    // getAllPolygon();
  }

  @override
  void cancel() {
    storage.cancel();
  }

  @override
  Future<ApiResult> deletePolygon(PolygonModel model) {
    return storage.deletePolygon(model);
  }

  @override
  Future<ApiResult<List<PolygonModel>>> getAllPolygon() {
    return storage.getAllPolygon();
  }

  @override
  bool get hasPolygons => storage.hasPolygons;

  @override
  Future<ApiResult<String>> notifyManager(String lat, String lng, String locationId) {
    return storage.notifyManager(lat, lng, locationId);
  }

  @override
  Stream<List<PolygonModel>> get polygonStream => storage.polygonStream;

  @override
  Future<List<PolygonModel>> get polygonsCompleter => storage.polygonsCompleter;

  @override
  Future<void> saveAllPolygon(List<PolygonModel> polygons) {
    return storage.saveAllPolygon(polygons);
  }

  @override
  Future<ApiResult<void>> savePolygon(PolygonModel model) {
    return storage.savePolygon(model);
  }

  @override
  Future<ApiResult> updatePolygon(PolygonModel model) {
    return storage.updatePolygon(model);
  }

  @override
  List<PolygonModel> get polygons => storage.polygons;

  @override
  Future<ApiResult<UserData>> temporaryOwner(TemporaryOwnerParams params) {
    return storage.temporaryOwner(params);
  }
  
  @override
  Future<ApiResult<bool>> removeTemporaryOwner(TemporaryOwnerParams params) {
    return storage.removeTemporaryOwner(params);
  }
}
