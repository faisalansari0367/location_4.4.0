import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mt;

class MapsToolkitService {
  static bool isInsidePolygon({
    required LatLng latLng,
    required List<LatLng> polygon,
    bool geodesic = false,
  }) {
    final point = mt.LatLng(latLng.latitude, latLng.longitude);
    return mt.PolygonUtil.containsLocation(point, _convertPoints(polygon), geodesic);
  }

  static num calculatePolygonArea(List<LatLng> polygon) {
    return mt.SphericalUtil.computeArea(_convertPoints(polygon));
  }

  static bool isClosedPolygon(List<LatLng> polygon) {
    return mt.PolygonUtil.isClosedPolygon(_convertPoints(polygon));
  }

  static List<mt.LatLng> _convertPoints(List<LatLng> data) {
    return data.map((latLng) => mt.LatLng(latLng.latitude, latLng.longitude)).toList();
  }
}
