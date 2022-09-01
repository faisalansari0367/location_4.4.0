import 'dart:async';
import 'dart:math';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/maps/location_service/geolocator_service.dart';
import 'package:background_location/ui/maps/location_service/map_toolkit_utils.dart';
import 'package:background_location/ui/maps/location_service/maps_popups.dart';
import 'package:background_location/ui/maps/location_service/polygons_service.dart';
import 'package:background_location/ui/maps/models/enums/filed_assets.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:local_notification/local_notification.dart';

import '../../../services/notifications/push_notifications.dart';
import '../location_service/maps_repo.dart';
import '../models/polygon_model.dart';
import '../view/widgets/dialog/notify_manager.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart'
//     show CameraPosition, CameraUpdate, GoogleMapController, LatLng, LatLngBounds;
// import 'package:location_repo/location_repo.dart' show LocationRepo, MapsRepo, PolygonLatLng, PolygonModel, Position;
// import 'package:location_repo/location_repo.dart' as location_repo;

part 'maps_state.dart';
// part 'maps_state.g.dart';

class MapsCubit extends Cubit<MapsState> {
  final NotificationService _notificationService;
  final PushNotificationService _pushNotificationService;
  final MapsRepo _mapsRepo;
  final PolygonsService _polygonsService;
  final Api api;

  MapsCubit(
    this._notificationService,
    this._mapsRepo,
    this._polygonsService,
    this._pushNotificationService,
    this.api,
  ) : super(
          MapsState(
            currentLocation: LatLng(
              -25.185575842417077,
              134.68900724218238,
            ),
          ),
        );

  final Completer<GoogleMapController> controller = Completer();
  late GoogleMapController mapController;
  StreamSubscription<Position>? _positionSubscription;

  Future<void> init() async {
    _getAllPolygon();
    updateCurrentLocation();
    getLocationUpdates();
  }

  bool canUserEdit(int? id) {
    if (id == null) return false;
    var id2 = api.getUserData()?.id;
    return id2 == id;
  }

  Future<void> doneEditing() async {
    if (state.currentPolygon == null) return;
    final result = await _mapsRepo.updatePolygon(state.currentPolygon!);
    if (state.currentPolygon != null) {
      result.when(
        success: (s) {
          emit(state.copyWith(isEditingFence: false, latLngs: []));
          _polygonsService.clear();
        },
        failure: (failure) => DialogService.failure(error: failure),
      );
    }
  }

  void startEditPolygon(PolygonModel polygon) {
    emit(state.copyWith(isEditingFence: true, latLngs: polygon.points, currentPolygon: polygon));
    // state.copyWith(latLngs: )
    _polygonsService.addPolygon(polygon.points);
  }

  UserData? get userData => api.getUserData();

  Future<void> _getAllPolygon() async {
    var allPolygon = await _mapsRepo.getAllPolygon();
    final polygonSet = <PolygonModel>{};
    // allPolygon.then((polygons) {
    allPolygon.when(
      success: (allPolygon) {
        allPolygon.forEach((element) {
          final data = PolygonModel(
            id: element.id!,
            name: element.name,
            points: element.points,
            color: element.color,
          );
          polygonSet.add(data);
        });
        emit(state.copyWith(polygons: polygonSet));
      },
      failure: (error) => DialogService.failure(error: error),
    );
    // });
  }

  void setIsAddingGeofence() {
    emit(state.copyWith(addingGeofence: !state.addingGeofence));
    // if (!state.addingGeofence) {
    //   addPolygon(state.latLngs);
    // }
  }

  void toggleIsEditingFence() {
    emit(state.copyWith(isEditingFence: !state.isEditingFence));
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
  // void addLatLng(LatLng latLng) {
  //   // print(state.latLngs);
  //   emit(state.copyWith(latLngs: List<LatLng>.from([...state.latLngs, latLng])));
  // }

  // void clearLastLatLng
  // void clearLastMarker() {
  //   final latlngs = state.latLngs;
  //   if (latlngs.length > 0) {
  //     latlngs.removeLast();
  //     // print(latlngs.length);
  //     emit(state.copyWith(latLngs: []));
  //     emit(state.copyWith(latLngs: latlngs));
  //     // once(listener, callback)

  //   }
  //   // emit(state.copyWith(latLngs: []));
  // }

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

  // List<LatLng> convertPoints(List<LatLng> list) {
  //   return list;
  //   // return list.map((e) => LatLng(e.latitude, e.longitude)).toList();
  // }

  void updatePolygon() {}

  void addPolygon(String name) async {
    final model = PolygonModel(
      name: name,
      color: state.selectedColor,
      points: _polygonsService.latLngs,
      id: Random().nextInt(10000000).toString(),
    );
    // final userData = await api.getUserData();
    final result = await _mapsRepo.savePolygon(model);
    result.when(
      success: (data) => _polygonsService.clear(),
      failure: (e) => DialogService.failure(error: e),
    );

    // _getAllPolygon();
    emit(
      state.copyWith(
        polygons: {
          ...state.polygons,
          PolygonModel(
            id: model.id!,
            name: name,
            points: _polygonsService.latLngs,
            color: state.selectedColor,
          )
        },
        latLngs: [],
      ),
    );
  }

  // void zoom() async {
  //   final zoom = await mapController.getZoomLevel();
  //   emit(state.copyWith(zoom: zoom + 5));
  // }

  void changeMapType(MapType type) async {
    emit(state.copyWith(mapType: type));
    //  final mapController = await controller.future;
    //  mapController.setMapStyle(type);
  }

  Future<void> updateCurrentLocation() async {
    await controller.future;
    final currentPosition = await GeolocatorService.getCurrentLatLng();
    final taget = LatLng(currentPosition.latitude, currentPosition.longitude);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: taget,
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
    mapController = controller;
    mapController.setMapStyle('[]');
    if (this.controller.isCompleted) return;
    this.controller.complete(controller);
  }

  PolygonModel? getPolygon() {
    final polygon = state.polygons.where(
      (element) => MapsToolkitService.isInsidePolygon(
        latLng: state.currentLocation,
        polygon: element.points,
      ),
    );
    if (polygon.isEmpty) return null;
    return polygon.first;
  }

  Future<void> notifyManager() async {
    print('notify manager api called');
    final userData = api.getUserData();
    final polygon = state.polygons.where(
      (element) => MapsToolkitService.isInsidePolygon(
        latLng: state.currentLocation,
        polygon: element.points,
      ),
    );
    if (polygon.isEmpty) return;
    // if (polygon.length == 1) {
    // print(polygon);
    final result = await _mapsRepo.notifyManager(
      userData!.pic!,
      state.currentLocation.latitude.toString(),
      state.currentLocation.longitude.toString(),
      polygon.first.id!,
    );
    result.when(
      success: (s) {
        DialogService.showDialog(child: NotifyManagerDialog());
      },
      failure: (e) => DialogService.failure(error: e),
    );
    // }
    // result.when();
    // result.w(() => null)
  }

  Future<void> zoom(double zoom) async {
    emit(state.copyWith(zoom: min(max(1, state.zoom + zoom), 20)));
    print(state.zoom);
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: state.currentLocation,
          zoom: state.zoom,
        ),
      ),
    );
  }

  void getLocationUpdates() {
    final popups = MapsPopups(notifyManager, _mapsRepo, this);
    _positionSubscription = GeolocatorService.instance.getPositionStream().listen((event) {
      var position = LatLng(event.latitude, event.longitude);
      emit(state.copyWith(currentLocation: position));
      final polygonsInCoverage = MapsToolkitService.isInsideAccuracy(
        latLng: position,
        polygons: state.polygons,
        accuracy: event.accuracy,
      );

      // mapController.animateCamera(
      //   CameraUpdate.newCameraPosition(
      //     CameraPosition(
      //       target: position,
      //       zoom: 20.151926040649414,
      //     ),
      //   ),
      // );
      // final polygon = state.polygons.where(
      //     (element) => MapsToolkitService.isInsidePolygon(latLng: state.currentLocation, polygon: element.points));

      popups.polygonsInCoverage.add(polygonsInCoverage);
      popups.controller.add(polygonsInCoverage.isNotEmpty);
    });
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _polygonsService.clear();
    _mapsRepo.cancel();
    return super.close();
  }

  // @override
  // MapsState? fromJson(Map<String, dynamic> json) {
  //   throw UnimplementedError();
  // }

  // @override
  // Map<String, dynamic>? toJson(MapsState state) {
  //   throw UnimplementedError();
  // }

  // Create a [PolyGeofenceService] instance and set options.

}
