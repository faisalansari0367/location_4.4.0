import 'package:location_repo/src/maps/maps_repo.dart';

abstract class MapsRepo {
  Future<List<PolygonModel>> getAllPolygon();
  Future<void> savePolygon(PolygonModel model);
  Future<void> init();
  Stream<List<PolygonModel>> get polygonStream;
}
