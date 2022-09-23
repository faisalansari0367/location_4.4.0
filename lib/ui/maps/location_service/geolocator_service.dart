import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeolocatorService {
  static final GeolocatorPlatform instance = GeolocatorPlatform.instance;
  static Future<Position> getCurrentPosition() async {
    try {
      final position = await instance.getCurrentPosition(locationSettings: _getLocationSettings);
      return position;
    } catch (e) {
      print('error from get current position $e');
      rethrow;
    }
  }

  static Future<Position?> getLastKnownPosition() async {
    return await instance.getLastKnownPosition();
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
    return instance.getPositionStream(locationSettings: _getLocationSettings);
  }

  static LocationSettings get _getLocationSettings {
    late LocationSettings locationSettings;

    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.best,

        // distanceFilter: 10,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 5),
      );
    } else if (Platform.isIOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.best,
        activityType: ActivityType.other,
        timeLimit: const Duration(seconds: 5),

        // distanceFilter: 10,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: true,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        // distanceFilter: 10,
      );
    }
    return locationSettings;
  }
}
