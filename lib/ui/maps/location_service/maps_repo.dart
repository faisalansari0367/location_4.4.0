import 'package:api_repo/api_result/api_result.dart';

import '../models/polygon_model.dart';

abstract class MapsRepo {
  Future<ApiResult<List<PolygonModel>>> getAllPolygon();
  Future<void> savePolygon(PolygonModel model);
  Future<void> init();
  Stream<List<PolygonModel>> get polygonStream;
}
