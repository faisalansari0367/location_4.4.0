import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/maps/cubit/track_polygons.dart';
import 'package:background_location/ui/maps/location_service/geolocator_service.dart';
import 'package:background_location/ui/maps/location_service/map_toolkit_utils.dart';
import 'package:background_location/ui/maps/location_service/polygons_service.dart';
import 'package:background_location/ui/maps/models/enums/filed_assets.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:local_notification/local_notification.dart';

import '../../../services/notifications/connectivity/connectivity_service.dart';
import '../../../services/notifications/push_notifications.dart';
import '../location_service/maps_repo.dart';
import '../location_service/maps_repo_local.dart';
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
  final PolygonModel? polygonId;
  final MapsRepo _mapsRepo;
  final PolygonsService _polygonsService;
  final Api api;
  final MapsRepoLocal mapsRepoLocal;
  late MapsRepo mapsRepo;

  MapsCubit(
    this._notificationService,
    this._mapsRepo,
    this._polygonsService,
    this._pushNotificationService,
    this.api,
    this.mapsRepoLocal, {
    this.polygonId,
  }) : super(
          const MapsState(
            currentLocation: LatLng(
              -25.185575842417077,
              134.68900724218238,
            ),
          ),
        ) {
    mapsRepo = _mapsRepo;
    MyConnectivity().connectionStream.listen((event) {
      mapsRepo = event ? _mapsRepo : mapsRepoLocal;
      emit(state.copyWith(isConnected: event));
      if (state.polygons.isEmpty) {
        _getAllPolygon();
      }
    });
  }

  final Completer<GoogleMapController> controller = Completer();
  late GoogleMapController mapController;
  StreamSubscription<Position>? _positionSubscription;

  Future<void> init() async {
    // so that device can determin the connectivity status
    await 200.milliseconds.delay();
    await updateCurrentLocation();
    await _getAllPolygon();
    if (polygonId != null) moveToSelectedPolygon(polygonId!);
    getLocationUpdates();
    emit(state.copyWith());
  }

  void moveToSelectedPolygon(PolygonModel model) {
    mapController.animateCamera(
      MapsToolkitService.boundsFromLatLngList(model.points),
    );
  }

  bool canUserEdit(int? id) {
    if (id == null) return false;
    final id2 = api.getUserData()?.id;
    // final roles = [Roles.producer, Roles.agent, Roles.consignee].contains(userData?.role?.camelCase?.getRole);
    return id2 == id;
  }

  Future<void> doneEditing() async {
    if (state.currentPolygon == null) return;
    // final polygon = state.currentPolygon?.color = state.selectedColor;
    final polygon = state.currentPolygon?.copyWith(color: state.selectedColor);

    final result = await mapsRepo.updatePolygon(polygon!);
    if (state.currentPolygon != null) {
      result.when(
        success: (s) {
          emit(state.copyWith(isEditingFence: false, latLngs: []));
          _polygonsService.clear();
        },
        failure: (failure) {
          emit(state.copyWith(isEditingFence: false, latLngs: []));
          _polygonsService.clear();
          DialogService.failure(error: failure);
        },
      );
    }
  }

  @override
  void emit(MapsState state) {
    if (isClosed) return;
    super.emit(state);
  }

  void startEditPolygon(PolygonModel polygon) {
    emit(state.copyWith(isEditingFence: true, latLngs: polygon.points, currentPolygon: polygon));
    // state.copyWith(latLngs: )
    _polygonsService.addPolygon(polygon.points);
  }

  UserData? get userData => api.getUserData();

  Future<void> _getAllPolygon() async {
    final allPolygon = await mapsRepo.getAllPolygon();
    final polygonSet = <PolygonModel>{};
    // allPolygon.then((polygons) {
    allPolygon.when(
      success: (allPolygon) {
        for (final element in allPolygon) {
          final data = PolygonModel(
            id: element.id!,
            name: element.name,
            points: element.points,
            color: element.color,
          );
          polygonSet.add(data);
        }
        emit(state.copyWith(polygons: polygonSet));
      },
      failure: (error) => DialogService.failure(error: error),
    );
    // });
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
    // print(controller.isCompleted);
    dev.log('getting current location');
    final result = await GeolocatorService.getLastKnownPosition();
    if (result != null) {
      final _lastPosition = LatLng(result.latitude, result.longitude);
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _lastPosition,
            zoom: 20.151926040649414,
          ),
        ),
      );
      emit(
        state.copyWith(
          currentLocation: _lastPosition,
        ),
      );
    }
    final currentPosition = await GeolocatorService.getCurrentPosition();
    dev.log('found current location ${currentPosition.toString()}');

    final target = LatLng(currentPosition.latitude, currentPosition.longitude);
    if (!controller.isCompleted) {
      await controller.future;
    }
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
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
    final result = await mapsRepo.notifyManager(
      userData!.pic!,
      state.currentLocation.latitude.toString(),
      state.currentLocation.longitude.toString(),
      polygon.first.id!,
    );
    result.when(
      success: (s) async {
        final name = '${polygon.first.createdBy?.firstName} ${polygon.first.createdBy?.lastName}';
        final manager = name.isEmpty ? 'Property Manager' : name;
        await DialogService.showDialog(
          child: NotifyManagerDialog(
            message: 'We have notified the ${manager} of your entry into the geofenced area',
          ),
        );
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

  final debouncer = Debouncer(delay: 1.seconds);
  PolygonModel? userIsInsidePolygonId;
  void getLocationUpdates() async {
    final trackPolygons = TrackPolygons(pic: userData!.pic!, mapsRepo: mapsRepo, api: api);
    // dev.log('lcoation updates is emitting');

    // final popups = MapsPopups(notifyManager, mapsRepo, this);
    final locationupdates = await GeolocatorService.getLocationUpdates();
    _positionSubscription = locationupdates.listen((event) {
      final position = LatLng(event.latitude, event.longitude);
      emit(state.copyWith(currentLocation: position));
      final polygonsInCoverage = MapsToolkitService.isInsideAccuracy(
        latLng: position,
        polygons: state.polygons,
        accuracy: event.accuracy,
      );
      // dev.log('message ${polygonsInCoverage.length}');

      if (polygonsInCoverage.isNotEmpty) {
        trackPolygons.update(polygonsInCoverage, position);
      }

      // state.polygons.map((e) => e.points)
      // state.polygons.forEach((element) {
      //   // element.points
      //   final userIsEntering = MapsToolkitService.isInsidePolygon(latLng: position, polygon: element.points);

      // });
      // print('polygons in coverage $polygonsInCoverage');
      // if (userIsInsidePolygonId != null) {
      //   final isInside = MapsToolkitService.isInsidePolygon(
      //     latLng: position,
      //     polygon: userIsInsidePolygonId!.points,
      //   );
      //   if (!isInside) {
      //     debouncer.call(() {
      //       mapsRepo.logBookEntry(
      //         userData!.pic!,
      //         null,
      //         userIsInsidePolygonId!.id!,
      //         isExiting: true,
      //       );
      //     });
      //   }
      // } else {
      //   if (polygonsInCoverage.isNotEmpty) {
      //     polygonsInCoverage.forEach((element) {
      //       final isInside = MapsToolkitService.isInsidePolygon(latLng: position, polygon: element.points);
      //       if (isInside) {
      //         debouncer.call(() {
      //           mapsRepo.logBookEntry(
      //             userData!.pic!,
      //             null,
      //             element.id!,
      //           );
      //           userIsInsidePolygonId = element;
      //         });
      //       }
      //     });
      //     // popups.showPopup(polygonsInCoverage);
      //   }
      // }
      // popups.polygonsInCoverage.add(polygonsInCoverage);
      // popups.controller.add(polygonsInCoverage.isNotEmpty);
    });
  }

  void _userIsInCoverage(Set<PolygonModel> polygons) {
    final userIsInCoverage = polygons.where((element) {
      return MapsToolkitService.isInsidePolygon(
        latLng: state.currentLocation,
        polygon: element.points,
      );
    });
    if (userIsInCoverage.isNotEmpty) {
      // show popup
    }
  }

  void stopLocationUpdates() => _positionSubscription?.cancel();

  @override
  Future<void> close() {
    stopLocationUpdates();
    _polygonsService.clear();
    mapsRepo.cancel();
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
