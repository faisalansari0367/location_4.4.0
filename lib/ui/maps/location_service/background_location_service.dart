import 'dart:async';
import 'dart:developer';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/maps/cubit/track_polygons.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'geolocator_service.dart';
import 'map_toolkit_utils.dart';

class GeofenceService {
  StreamSubscription<Position>? _positionSubscription;
  late TrackPolygons trackPolygons;
  Set<PolygonModel> polygons = {};
  ValueChanged<Position>? onLocationChanged;

  GeofenceService({
    required MapsRepo mapsRepo,
    required Api api,
  }) {
    mapsRepo.polygonStream.listen(
      (event) => polygons = event.toSet(),
    );
    trackPolygons = TrackPolygons(mapsRepo: mapsRepo, api: api);
  }

  Future<void> getLocationUpdates(ValueChanged<Position>? onLocationChanged) async {
    log('Polygons: ${polygons.length}');
    _positionSubscription?.cancel();
    final locationupdates = await GeolocatorService.getLocationUpdates();
    _positionSubscription = locationupdates.listen((event) {
      final position = LatLng(event.latitude, event.longitude);
      final polygonsInCoverage = MapsToolkitService.isInsideAccuracy(
        latLng: position,
        polygons: polygons,
        accuracy: event.accuracy,
      );
      if (polygonsInCoverage.isNotEmpty) {
        trackPolygons.update(polygonsInCoverage, position);
      }
      onLocationChanged?.call(event);
    }, onError: (e) {
      print(e);
    });
  }

  void stopTimers() => trackPolygons.dispose();

  void cancel() => _positionSubscription?.cancel();
}
