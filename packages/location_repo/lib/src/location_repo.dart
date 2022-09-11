import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mt;
import 'package:maps_toolkit/maps_toolkit.dart';

import 'get_address_utils.dart';

class LocationRepo {
  static final GeolocatorPlatform instance = GeolocatorPlatform.instance;

  static num getDistance(double lat1, double lng1, double lat2, double lng2) {
    final distance = mt.SphericalUtil.computeDistanceBetween(
      mt.LatLng(lat1, lng1),
      mt.LatLng(lat2, lng2),
    );
    return distance;
  }

  static Future<Position> getCurrentPosition() async {
    try {
      final position = await instance.getCurrentPosition(locationSettings: _getLocationSettings);
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
    return instance.getPositionStream(locationSettings: _getLocationSettings);
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

  static bool isInsidePolygon({
    required LatLng latLng,
    required List<LatLng> polygon,
    bool geodesic = false,
  }) {
    return mt.PolygonUtil.containsLocation(latLng, polygon, geodesic);
  }

  static num calculatePolygonArea(List<LatLng> polygon) {
    return mt.SphericalUtil.computeArea(polygon);
  }

  static bool isClosedPolygon(List<LatLng> polygon) {
    return mt.PolygonUtil.isClosedPolygon(polygon);
  }

  static LocationSettings get _getLocationSettings {
    late LocationSettings locationSettings;

    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
        //(Optional) Set foreground notification config to keep the app alive
        //when going to the background
      );
    } else if (Platform.isIOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.best,
        activityType: ActivityType.other,
        distanceFilter: 10,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: true,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    }
    return locationSettings;
  }
}
