import 'package:background_location/ui/maps/models/polygon_model.dart';
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

  // isInisdeAccuracy
  static Set<PolygonModel> isInsideAccuracy({
    required LatLng latLng,
    required Set<PolygonModel> polygons,
    required num accuracy,
    // bool geodesic = false,
  }) {
    final inRadius = <PolygonModel>{};
    polygons.forEach((element) {
      var result = false;
      final isLocationOnPath = isInsidePolygon(latLng: latLng, polygon: element.points);
      if (!isLocationOnPath) {
        result = _mostNearPolyline(element.points, accuracy, latLng);
      }
      if (result) {
        inRadius.add(element);
      }
    });
    return inRadius;
  }

  static bool _mostNearPolyline(List<LatLng> polygon, accuracy, LatLng pos) {
    var result = false;
    // final polyLines = <List<LatLng>>[];
    for (var i = 0; i < polygon.length; i++) {
      final point = polygon[i];
      final nextPoint = polygon[i == polygon.length - 1 ? i : i + 1];
      final list = [point, nextPoint];
      final isLocationOnPath =
          mt.PolygonUtil.isLocationOnPath(_fromLatLng(pos), _convertPoints(list), false, tolerance: accuracy);
      // final distance = _distance(polygon[i], polygon[i+1]);
      if (isLocationOnPath) {
        result = true;
        break;
      }
    }
    return result;
    // polygon.forEach((e) {
    //   return _distance(e, );

    // });
  }

  static distance(LatLng from, LatLng to) {
    final distance = mt.SphericalUtil.computeDistanceBetween(_fromLatLng(from), _fromLatLng(to));
    return distance;
  }

  static mt.LatLng _fromLatLng(LatLng latLng) {
    return mt.LatLng(latLng.latitude, latLng.longitude);
  }
}
