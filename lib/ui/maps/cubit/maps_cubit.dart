import 'dart:async';

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
      // emit(state.copyWith(polygons: ))
      // state.copyWith(latLngs: []);
    }
  }

  // final list = <LatLng>[];
  void latLngs(LatLng latLng) {
    print(state.latLngs);
    emit(state.copyWith(latLngs: List<LatLng>.from([...state.latLngs, latLng])));
  }

  void addPolygon(List<LatLng> latLngs) {
    if (latLngs.isEmpty) {
      return;
    }

    emit(
      state.copyWith(
        polygons: {...state.polygons, List<LatLng>.from(latLngs)},
        latLngs: [],
      ),
    );
  }

  void changeMapType(MapType type) {
    emit(state.copyWith(mapType: type));
  }

  void updateCurrentLocation() async {
    final currentPosition = await LocationRepo.getCurrentLatLng();
    print(currentPosition);
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
