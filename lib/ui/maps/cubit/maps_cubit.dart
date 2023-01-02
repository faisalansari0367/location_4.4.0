import 'dart:async';
import 'dart:math';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/ui/maps/location_service/geofence_service.dart';
import 'package:bioplus/ui/maps/location_service/geolocator_service.dart';
import 'package:bioplus/ui/maps/location_service/map_toolkit_utils.dart';
import 'package:bioplus/ui/maps/location_service/polygons_service.dart';
import 'package:bioplus/ui/maps/models/enums/filed_assets.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../services/notifications/push_notifications.dart';
import '../location_service/maps_repo_local.dart';
import '../models/polygon_model.dart';

part 'maps_state.dart';

class MapsCubit extends BaseModel {
  // ignore: unused_field
  // final NotificationService _notificationService;
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
    // this._notificationService,
    // this._mapsRepo,
    this._polygonsService,
    this._pushNotificationService,
    this.api,
    this.mapsRepoLocal, {
    required this.geofenceService,
    this.polygonId,
  }) : super(context) {
    init();
  }
  static const _latLng = LatLng(-25.185575842417077, 134.68900724218238);
  MapsState state = const MapsState(currentLocation: _latLng);

  final Completer<GoogleMapController> controller = Completer();
  Future<GoogleMapController> get mapController async => await controller.future;

  Future<void> init() async {
    geofenceService.init(mapsRepo, localApi);
    // so that device can determine the connectivity status
    await 100.milliseconds.delay();
    if (state.polygons.isEmpty) {
      await _getAllPolygon();
    }
    updateCurrentLocation();
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
    final currentUserId = api.getUserData()?.id;
    // final roles = [Roles.producer, Roles.agent, Roles.consignee].contains(userData?.role?.camelCase?.getRole);
    return currentUserId == id;
  }

  void toggleTracking() {
    emit(state.copyWith(isTracking: !state.isTracking));
  }

  Future<void> doneEditing() async {
    if (state.currentPolygon == null) return;
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

  void updatePolygon(PolygonModel polygon) {
    emit(state.copyWith(
      currentPolygon: polygon,
    ));
  }

  // @override
  void emit(MapsState state, {bool notify = true}) {
    if (!mounted) return;
    this.state = state;
    if (notify) notifyListeners();
  }

  void startEditPolygon(PolygonModel polygon) {
    emit(state.copyWith(isEditingFence: true, polylines: polygon.points, currentPolygon: polygon));
    _polygonsService.addPolygon(polygon.points);
  }

  UserData? get userData => api.getUserData();

  Future<void> _getAllPolygon() async {
    if (mapsRepo.hasPolygons) return;
    final allPolygon = await mapsRepo.getAllPolygon();
    allPolygon.when(
      success: (allPolygon) {
        emit(state.copyWith(polygons: allPolygon.toSet()));
        // getLocationUpdates();
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

  void setPolygonColor(Color color) {
    emit(state.copyWith(polygonColor: color));
  }

  void addPolygon(String name, {String? companyOwner}) async {
    final model = PolygonModel(
      name: name,
      color: state.selectedColor,
      points: _polygonsService.latLngs,
      id: Random().nextInt(10000000).toString(),
      companyOwner: companyOwner,
    );
    final result = await mapsRepo.savePolygon(model);
    result.when(
      success: (data) => _polygonsService.clear(),
      failure: (e) {
        DialogService.failure(error: e);
        _polygonsService.clear();
      },
    );

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

  void changeMapType(MapType type) async {
    emit(state.copyWith(mapType: type));
  }

  Future<void> updateCurrentLocation() async {
    final permission = await GeolocatorService.locationPermission();
    if (!permission) {
      return;
    }
    final result = await GeolocatorService.getLastKnownPosition();
    if (result != null) {
      final _lastPosition = LatLng(result.latitude, result.longitude);
      animateCamera(_lastPosition);
      emit(state.copyWith(currentLocation: _lastPosition));
    }
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

  Future<void> getLocationUpdates() async {
    print('waiting for polygons to complete');
    // await mapsRepo.polygonsCompleter;
    print('polygons completed');
    // notifyListeners();

    geofenceService.getLocationUpdates((event) {
      final position = LatLng(event.latitude, event.longitude);
      emit(
        state.copyWith(currentLocation: position),
        notify: false,
      );
      if (state.isTracking) {
        if (event.speed > 0) animateCamera(position);
      }
    });
  }

  @override
  Future<void> dispose() async {
    // geofenceService.stopTimers();
    _polygonsService.clear();
    super.dispose();
  }
}
