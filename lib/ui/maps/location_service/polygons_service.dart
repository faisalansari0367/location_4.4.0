import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/subjects.dart';

class PolygonsService {
  final _controller = BehaviorSubject<List<LatLng>>.seeded([]);

  PolygonsService();

  void addLatLng(LatLng latLng) {
    _controller.add([..._controller.value, latLng]);
  }

  void addPolygon(List<LatLng> points) {
    _controller.add(points);
  }

  void removeLastLatLng() {
    final list = _controller.value;
    if (list.isEmpty) return;
    list.removeLast();
    _controller.add(list);
  }

  void updateMarkers(LatLng latLng, int index) {
    final list = latLngs;
    list[index] = latLng;
    _controller.add(list);
  }

  void clear() => _controller.add([]);

  List<LatLng> get latLngs => _controller.value;
  Stream<List<LatLng>> get stream => _controller.stream;
}
