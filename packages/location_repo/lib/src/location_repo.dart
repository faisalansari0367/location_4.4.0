import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mt;
import 'package:maps_toolkit/maps_toolkit.dart';

import 'get_address_utils.dart';

class LocationRepo {
  bool _isInitiated = false;
  static late GeolocatorPlatform instance;

  LocationRepo() {
    if (_isInitiated) return;
    _isInitiated = true;
    _init();
  }

  Future<void> _init() async {
    instance = GeolocatorPlatform.instance;
  }

  static num getDistance(double lat1, double lng1, double lat2, double lng2) {
    final distance = mt.SphericalUtil.computeDistanceBetween(
      mt.LatLng(lat1, lng1),
      mt.LatLng(lat2, lng2),
    );
    return distance;
  }

  static Future<Position> getCurrentPosition() async {
    try {
      const settings = LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      );
      final position = await instance.getCurrentPosition(locationSettings: settings);
      return position;
    } catch (e) {
      print('error from get current position $e');
      rethrow;
    }
  }

  static Future<LatLng> getCurrentLatLng() async {
    final position = await getCurrentPosition();
    final latLng = LatLng(position.latitude, position.longitude);
    return latLng;
  }

  static Future<Stream<Position>> getLocationUpdates() async {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );
    return instance.getPositionStream(locationSettings: settings);
  }

  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    String currentLocation;
    try {
      final placeMarks = await placemarkFromCoordinates(lat, lng);
      currentLocation = GetAddressUtils.getAddressFromPlaceMark(placeMarks);
    } catch (e) {
      currentLocation = 'Network error, please try again.';
    }
    return currentLocation;
  }
}
