import 'dart:async';
import 'dart:math';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/provider/base_model.dart';
import 'package:background_location/ui/maps/location_service/background_location_service.dart';
import 'package:background_location/ui/maps/location_service/geolocator_service.dart';
import 'package:background_location/ui/maps/location_service/map_toolkit_utils.dart';
import 'package:background_location/ui/maps/location_service/polygons_service.dart';
import 'package:background_location/ui/maps/models/enums/filed_assets.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:local_notification/local_notification.dart';

import '../../../services/notifications/push_notifications.dart';
import '../location_service/maps_repo_local.dart';
import '../models/polygon_model.dart';

part 'maps_state.dart';

class MapsCubit extends BaseModel {
  // ignore: unused_field
  final NotificationService _notificationService;
  // ignore: unused_field
  final PushNotificationService _pushNotificationService;
  final PolygonModel? polygonId;
  // final MapsRepo _mapsRepo;
  final PolygonsService _polygonsService;
  final GeofenceService geofenceService;
  final Api api;
  final MapsRepoLocal mapsRepoLocal;
  // late MapsRepo mapsRepo;
  // late TrackPolygons trackPolygons;

  MapsCubit(
    BuildContext context,
    this._notificationService,
    // this._mapsRepo,
    this._polygonsService,
    this._pushNotificationService,
    this.api,
    this.mapsRepoLocal, {
    required this.geofenceService,
    this.polygonId,
  }) : super(context) {
    // mapsRepo = _mapsRepo;
    // trackPolygons = TrackPolygons(mapsRepo: mapsRepo, api: api);
    // MyConnectivity().connectionStream.listen((event) {
    //   mapsRepo = event ? _mapsRepo : mapsRepoLocal;
    //   emit(state.copyWith(isConnected: event));
    // });

    init();
  }

  MapsState state = const MapsState(
    currentLocation: LatLng(-25.185575842417077, 134.68900724218238),
  );

  final Completer<GoogleMapController> controller = Completer();
  Future<GoogleMapController> get mapController async => await controller.future;
  // StreamSubscription<Position>? _positionSubscription;

  Future<void> init() async {
    updateCurrentLocation();
    // so that device can determine the connectivity status
    await 100.milliseconds.delay();
    if (state.polygons.isEmpty) {
      _getAllPolygon();
    }
    getLocationUpdates();
    polygonsStream();
    polylinesStream();
  }

  void polygonsStream() {
    mapsRepo.polygonStream.listen((event) {
      emit(state.copyWith(polygons: event.toSet()));
    });
  }

  void polylinesStream() {
    _polygonsService.stream.listen((event) {
      emit(state.copyWith(polylines: event));
    });
  }

  void moveToSelectedPolygon(PolygonModel model) async {
    (await mapController).animateCamera(
      MapsToolkitService.boundsFromLatLngList(model.points),
    );
  }

  bool canUserEdit(int? id) {
    if (id == null) return false;
    final id2 = api.getUserData()?.id;
    // final roles = [Roles.producer, Roles.agent, Roles.consignee].contains(userData?.role?.camelCase?.getRole);
    return id2 == id;
  }

  void toggleTracking() {
    emit(state.copyWith(isTracking: !state.isTracking));
  }

  Future<void> doneEditing() async {
    if (state.currentPolygon == null) return;
    // final polygon = state.currentPolygon?.color = state.selectedColor;
    final polygon = state.currentPolygon?.copyWith(color: state.selectedColor);

    final result = await mapsRepo.updatePolygon(polygon!);
    if (state.currentPolygon != null) {
      result.when(
        success: (s) {
          emit(state.copyWith(isEditingFence: false, polylines: []));
          _polygonsService.clear();
        },
        failure: (failure) {
          emit(state.copyWith(isEditingFence: false, polylines: []));
          _polygonsService.clear();
          DialogService.failure(error: failure);
        },
      );
    }
  }

  // @override
  void emit(MapsState state) {
    if (!mounted) return;
    this.state = state;
    notifyListeners();
  }

  void startEditPolygon(PolygonModel polygon) {
    emit(state.copyWith(isEditingFence: true, polylines: polygon.points, currentPolygon: polygon));
    _polygonsService.addPolygon(polygon.points);
  }

  UserData? get userData => api.getUserData();

  Future<void> _getAllPolygon() async {
    if (mapsRepo.hasPolygons && state.polygons.isNotEmpty) return;
    final allPolygon = await mapsRepo.getAllPolygon();
    allPolygon.when(
      success: (allPolygon) {
        emit(state.copyWith(polygons: allPolygon.toSet()));
      },
      failure: (error) => DialogService.failure(error: error),
    );
  }

  void setIsAddingGeofence() {
    emit(state.copyWith(addingGeofence: !state.addingGeofence));
  }

  void toggleIsEditingFence() {
    emit(state.copyWith(isEditingFence: !state.isEditingFence));
  }

  void setAssetColor(Color color) {
    emit(state.copyWith(selectedColor: color));
  }

  void addPolygon(String name) async {
    final model = PolygonModel(
      name: name,
      color: state.selectedColor,
      points: _polygonsService.latLngs,
      id: Random().nextInt(10000000).toString(),
    );
    // final userData = await api.getUserData();
    final result = await mapsRepo.savePolygon(model);
    result.when(
      success: (data) => _polygonsService.clear(),
      failure: (e) {
        DialogService.failure(error: e);
        _polygonsService.clear();
      },
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
        polylines: [],
      ),
    );
  }

  // void zoom() async {
  //   final zoom = await mapController.getZoomLevel();
  //   emit(state.copyWith(zoom: zoom + 5));
  // }

  void changeMapType(MapType type) async {
    emit(state.copyWith(mapType: type));
  }

  Future<void> updateCurrentLocation() async {
    final result = await GeolocatorService.getLastKnownPosition();
    if (result != null) {
      final _lastPosition = LatLng(result.latitude, result.longitude);
      animateCamera(_lastPosition);
      emit(state.copyWith(currentLocation: _lastPosition));
    }
    final currentPosition = await GeolocatorService.getCurrentPosition();
    final target = LatLng(currentPosition.latitude, currentPosition.longitude);

    animateCamera(target);
    emit(state.copyWith(currentLocation: target));
  }

  void animateCamera(LatLng latLng) async {
    if (!mounted) return;
    (await controller.future).animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 20.151926040649414,
        ),
      ),
    );
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    if (this.controller.isCompleted) {
      (await mapController).setMapStyle('[]');
      return;
    }
    this.controller.complete(controller);
  }

  // PolygonModel? getPolygon() {
  //   final polygon = state.polygons.where(
  //     (element) => MapsToolkitService.isInsidePolygon(
  //       latLng: state.currentLocation,
  //       polygon: element.points,
  //     ),
  //   );
  //   if (polygon.isEmpty) return null;
  //   return polygon.first;
  // }

  // Future<void> zoom(double zoom) async {
  //   emit(state.copyWith(zoom: min(max(1, state.zoom + zoom), 20)));
  //   print(state.zoom);
  //   await mapController.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: state.currentLocation,
  //         zoom: state.zoom,
  //       ),
  //     ),
  //   );
  // }

  Future<void> getLocationUpdates() async {
    await mapsRepo.polygonsCompleter;

    geofenceService.getLocationUpdates((event) {
      final position = LatLng(event.latitude, event.longitude);
      // print(position);

      emit(state.copyWith(currentLocation: position));
      if (state.isTracking) {
        if (event.speed > 0) animateCamera(position);
      }
    });
    // final locationupdates = await GeolocatorService.getLocationUpdates();
    // _positionSubscription = locationupdates.listen((event) {

    //   final polygonsInCoverage = MapsToolkitService.isInsideAccuracy(
    //     latLng: position,
    //     polygons: state.polygons,
    //     accuracy: event.accuracy,
    //   );

    //   if (polygonsInCoverage.isNotEmpty) {
    //     trackPolygons.update(polygonsInCoverage, position);
    //   }
    // });
  }

  // void stopLocationUpdates() => _positionSubscription?.cancel();
  @override
  Future<void> dispose() async {
    geofenceService.stopTimers();
    _polygonsService.clear();
    super.dispose();
  }
}
