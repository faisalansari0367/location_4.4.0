import '../models/polygon_model.dart';

abstract class MapsRepo {
  Future<List<PolygonModel>> getAllPolygon();
  Future<void> savePolygon(PolygonModel model);
  Future<void> init();
  Stream<List<PolygonModel>> get polygonStream;
}
