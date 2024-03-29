import 'dart:async';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/maps/cubit/track_polygons.dart';
import 'package:bioplus/ui/maps/location_service/geolocator_service.dart';
import 'package:bioplus/ui/maps/location_service/map_toolkit_utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeofenceService {
  StreamSubscription<Position>? _positionSubscription;
  late TrackPolygons trackPolygons;
  Set<PolygonModel> polygons = {};
  ValueChanged<Position>? onLocationChanged;
  // late Api api;
  // late MapsRepo mapsRepo;

  // static bool _init = false;

  GeofenceService();

  Future<void> init(GeofencesRepo mapsRepo, Api api) async {
    // if (_init) return;
    trackPolygons = TrackPolygons(geofenceRepo: mapsRepo, api: api);
    mapsRepo.polygonStream.listen((event) => polygons = event.toSet());

    // _init = true;
  }

  Future<void> getLocationUpdates(ValueChanged<Position>? onLocationChanged) async {
    await _positionSubscription?.cancel();
    final locationupdates = await GeolocatorService.getLocationUpdates();
    _positionSubscription = locationupdates.listen((event) {
      // showNotification(title: 'monitoring', body: '${event.latitude}, ${event.longitude}');

      final position = LatLng(event.latitude, event.longitude);
      final polygonsInCoverage = MapsToolkitService.isInsideAccuracy(
        latLng: position,
        polygons: polygons,
        accuracy: event.accuracy,
      );

      // if (polygonsInCoverage.isNotEmpty) {
      trackPolygons.update(polygonsInCoverage, position);
      // }
      onLocationChanged?.call(event);
    }, onError: (e) {
      print(e);
    },);
  }

  void stopTimers() => trackPolygons.dispose();

  void cancel() => _positionSubscription?.cancel();
}
