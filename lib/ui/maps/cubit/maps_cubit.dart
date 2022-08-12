import 'dart:async';

import 'package:background_location/ui/maps/models/enums/filed_assets.dart';
import 'package:background_location/ui/maps/models/polygon_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:local_notification/local_notification.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart'
//     show CameraPosition, CameraUpdate, GoogleMapController, LatLng, LatLngBounds;
import 'package:location_repo/location_repo.dart' show LocationRepo, Position;
import 'package:location_repo/location_repo.dart' as location_repo;

part 'maps_state.dart';
// part 'maps_state.g.dart';

class MapsCubit extends Cubit<MapsState> {
  final NotificationService _notificationService;
  MapsCubit(this._notificationService)
      : super(MapsState(currentLocation: LatLng(-25.185575842417077, 134.68900724218238)));

  final Completer<GoogleMapController> controller = Completer();
  late GoogleMapController mapController;
  StreamSubscription<Position>? _positionSubscription;

  Future<void> init() async {
    updateCurrentLocation();
    getLocationUpdates();
  }

  void setIsAddingGeofence() {
    emit(state.copyWith(addingGeofence: !state.addingGeofence));
    // if (!state.addingGeofence) {
    //   addPolygon(state.latLngs);
    // }
  }

  // @overrides
  // void onChange(Change<MapsState> change) {
  //   print(change);
  //   super.onChange(change);
  // }

  void setAssetColor(Color color) {
    emit(state.copyWith(selectedColor: color));
  }

  // final list = <LatLng>[];
  void addLatLng(LatLng latLng) {
    // print(state.latLngs);
    emit(state.copyWith(latLngs: List<LatLng>.from([...state.latLngs, latLng])));

  }

  // void clearLastLatLng
  void clearLastMarker() {
    final latlngs = state.latLngs;
    if (latlngs.length > 0) {
      latlngs.removeLast();
      // print(latlngs.length);
      emit(state.copyWith(latLngs: []));
      emit(state.copyWith(latLngs: latlngs));
      // once(listener, callback)

    }
    // emit(state.copyWith(latLngs: []));
  }

  // void addPolygon(List<LatLng> latLngs) {
  //   if (latLngs.isEmpty) {
  //     return;
  //   }

  //   emit(
  //     state.copyWith(
  //       polygons: {
  //         ...state.polygons,
  //         PolygonData(
  //           points: latLngs,
  //           type: state.fieldAsset,
  //         )
  //       },
  //       latLngs: [],
  //     ),
  //   );
  // }

  void addPolygon(String name) {
    emit(
      state.copyWith(
        polygons: {
          ...state.polygons,
          PolygonData(
            name: name,
            points: state.latLngs,
            // type: state.fieldAsset,
            color: state.selectedColor,
          )
        },
        latLngs: [],
      ),
    );
  }

  void zoom() async {
    final zoom = await mapController.getZoomLevel();
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
    await controller.future;
    final currentPosition = await LocationRepo.getCurrentLatLng();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            currentPosition.latitude,
            currentPosition.longitude,
          ),
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
    mapController = controller;
    mapController.setMapStyle('[]');
    if (this.controller.isCompleted) return;
    this.controller.complete(controller);
  }

  void getLocationUpdates() {
    _positionSubscription = LocationRepo.instance.getPositionStream().listen((event) {
      // print(event);
      final distance = LocationRepo.getDistance(
        state.currentLocation.latitude,
        state.currentLocation.longitude,
        event.latitude,
        event.longitude,
      );

      // _mapController.animateCamera(
      //   CameraUpdate.newCameraPosition(
      //     CameraPosition(
      //       target: LatLng(event.latitude, event.longitude),
      //       zoom: 20.151926040649414,
      //     ),
      //   ),
      // );
      // for (var i = 0; i < state.polygons.length; i++) {

      // }
      state.polygons.forEach((element) {
        final polygonPoints = _getMtLatLangs(element.points);
        final isInsidePolygon = LocationRepo.isInsidePolygon(
            latLng: location_repo.LatLng(event.latitude, event.longitude), polygon: polygonPoints);
        // if (state.insideFence == isInsidePolygon) return;
        emit(state.copyWith(insideFence: isInsidePolygon, currentPolygon: element));
      });
      // if (distance > 40) {
      //   emit(state.copyWith(insideFence: false));
      // } else {
      //   // if(isInside) return;
      //   emit(state.copyWith(insideFence: true));
      // }
    });
  }

  List<location_repo.LatLng> _getMtLatLangs(List<LatLng> polypoints) =>
      polypoints.map((e) => location_repo.LatLng(e.latitude, e.longitude)).toList();

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    return super.close();
  }

  // @override
  // MapsState? fromJson(Map<String, dynamic> json) {
  //   // TODO: implement fromJson
  //   throw UnimplementedError();
  // }

  // @override
  // Map<String, dynamic>? toJson(MapsState state) {
  //   // TODO: implement toJson
  //   throw UnimplementedError();
  // }

  // Create a [PolyGeofenceService] instance and set options.

}
