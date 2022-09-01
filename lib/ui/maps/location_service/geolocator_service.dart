import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeolocatorService {
  static final GeolocatorPlatform instance = GeolocatorPlatform.instance;
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

  static Future<bool> openLocationSettings() async {
    return await instance.openLocationSettings();
  }

  static Future<bool> locationPermission() async {
    final result = await instance.checkPermission();
    var value = true;
    switch (result) {
      case LocationPermission.denied:
        value = false;
        break;
      case LocationPermission.deniedForever:
        value = false;
        break;
      case LocationPermission.whileInUse:
        value = true;
        break;
      case LocationPermission.always:
        value = true;
        break;
      default:
        value = false;
    }
    return value;
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
}
