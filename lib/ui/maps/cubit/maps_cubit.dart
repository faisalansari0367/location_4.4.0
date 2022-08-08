import 'dart:async';

import 'package:background_location/ui/maps/models/enums/filed_assets.dart';
import 'package:background_location/ui/maps/models/polygon_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart'
//     show CameraPosition, CameraUpdate, GoogleMapController, LatLng, LatLngBounds;
import 'package:location_repo/location_repo.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  MapsCubit() : super(MapsState(currentLocation: LatLng(28.4923496, 77.2289945)));

  final Completer<GoogleMapController> controller = Completer();
  late GoogleMapController _mapController;
  StreamSubscription<Position>? _positionSubscription;

  Future<void> init() async {
    updateCurrentLocation();
    // getLocationUpdates();
  }

  void setIsAddingGeofence() {
    emit(state.copyWith(addingGeofence: !state.addingGeofence));
    if (!state.addingGeofence) {
      addPolygon(state.latLngs);
    }
  }

  void setAssetColor(FieldAssets fieldAsset) {
    emit(state.copyWith(fieldAsset: fieldAsset));
  }

  // final list = <LatLng>[];
  void addLatLng(LatLng latLng) {
    print(state.latLngs);
    emit(state.copyWith(latLngs: List<LatLng>.from([...state.latLngs, latLng])));
  }

  void addPolygon(List<LatLng> latLngs) {
    if (latLngs.isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        polygons: {...state.polygons, PolygonData(points: latLngs, type: state.fieldAsset)},
        latLngs: [],
      ),
    );
  }

  void zoom() async {
    final zoom = await _mapController.getZoomLevel();
    emit(state.copyWith(zoom: zoom + 5));
  }

  void changeMapType(MapType type) async {
    emit(state.copyWith(mapType: type));
    //  final mapController = await controller.future;
    //  mapController.setMapStyle(type);
  }

  void onMarkerDragEnd(LatLng latLng, int index) {
    final latlngs = state.latLngs;
    latlngs[index] = latLng;
    emit(state.copyWith(latLngs: List<LatLng>.from(latlngs)));
  }

  Future<void> updateCurrentLocation() async {
    final currentPosition = await LocationRepo.getCurrentLatLng();

    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 20.151926040649414,
        ),
      ),
    );
    emit(
      state.copyWith(
        // insideFence: LocationRepo().isInsidePolygon(latLng: LatLng(
        //   currentPosition.latitude,
        //   currentPosition.longitude,
        // ), polygon: ),
        currentLocation: LatLng(
          currentPosition.latitude,
          currentPosition.longitude,
        ),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (!this.controller.isCompleted) return;
    this.controller.complete(controller);
  }

  void getLocationUpdates() {
    _positionSubscription = LocationRepo.instance.getPositionStream().listen((event) {
      print(event);
      final distance = LocationRepo.getDistance(
        state.currentLocation.latitude,
        state.currentLocation.longitude,
        event.latitude,
        event.longitude,
      );

      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(event.latitude, event.longitude),
            zoom: 20.151926040649414,
          ),
        ),
      );
      if (distance > 40) {
        emit(state.copyWith(insideFence: false));
      } else {
        // if(isInside) return;
        emit(state.copyWith(insideFence: true));
      }
    });
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    return super.close();
  }

  // Create a [PolyGeofenceService] instance and set options.

}
