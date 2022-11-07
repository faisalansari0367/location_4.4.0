import 'package:api_repo/api_result/api_result.dart';

import '../models/polygon_model.dart';

abstract class MapsRepo {
  Future<ApiResult<List<PolygonModel>>> getAllPolygon();
  Future<ApiResult<void>> savePolygon(PolygonModel model);
  Future<void> init();
  Stream<List<PolygonModel>> get polygonStream;
  Future<ApiResult<String>> notifyManager(String pic, String lat, String lng, String locationId);
  Future<ApiResult<dynamic>> updatePolygon(PolygonModel model);
  Future<ApiResult<dynamic>> deletePolygon(PolygonModel model);
  Future<void> saveAllPolygon(List<PolygonModel> polygons);
  void cancel();
}
