import 'dart:developer';
import 'dart:io';

import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/dialogs/location_permission_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
// import 'package:background_location/background_location.dart';

class GeolocatorService {
  static final GeolocatorPlatform instance = GeolocatorPlatform.instance;

  Future<void> init() async {}

  static Future<Position> getCurrentPosition() async {
    try {
      final locationService = location.Location();
      final result = await locationService.requestService();
      if (!result) {
        await DialogService.showDialog(
          child: const LocationPermissionDialog(),
        );
        throw Future.error('Location services not enabled');
      }

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
    final _location = location.Location();
    await _location.enableBackgroundMode(enable: true);
    await _location.changeSettings(distanceFilter: 0, accuracy: location.LocationAccuracy.high);
    final isBackgroundMode = await _location.isBackgroundModeEnabled();
    print('isBackgroundMode $isBackgroundMode');
    final stream = _location.onLocationChanged.map(_getPosition);
    return stream;
  }

  static Position _getPosition(location.LocationData event) {
    final position = Position(
      latitude: event.latitude!,
      longitude: event.longitude!,
      // timestamp: DateTime.now(),
      timestamp: DateTime.now(),
      accuracy: event.accuracy!,
      altitude: event.altitude!,
      heading: event.heading!,
      speed: event.speed!,
      speedAccuracy: event.speedAccuracy!,
    );
    log('position ${position.toJson()}');
    return position;
  }

  static LocationSettings get _getLocationSettings {
    // const duration = Duration(seconds: 1);
    late LocationSettings locationSettings;

    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        // foregroundNotificationConfig: ForegroundNotificationConfig(
        //   notificationTitle: 'Monitoring in background',
        //   notificationText: 'We are monitor ing your entry and exit from locations',
        // ),
        // distanceFilter: 0,

        // forceLocationManager: true,
        intervalDuration: const Duration(),
        // intervalDuration: duration,
      );
    } else if (Platform.isIOS) {
      locationSettings = AppleSettings(
        // timeLimit: duration,
        pauseLocationUpdatesAutomatically: false,

        showBackgroundLocationIndicator: true,
        accuracy: LocationAccuracy.best,

        // activityType: Acti
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
