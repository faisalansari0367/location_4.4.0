import 'dart:async';
import 'dart:math';

import 'package:background_location/ui/maps/location_service/geolocator_service.dart';
import 'package:background_location/ui/maps/location_service/map_toolkit_utils.dart';
import 'package:background_location/ui/maps/location_service/maps_popups.dart';
import 'package:background_location/ui/maps/models/enums/filed_assets.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:local_notification/local_notification.dart';

import '../location_service/maps_repo.dart';
import '../models/polygon_model.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart'
//     show CameraPosition, CameraUpdate, GoogleMapController, LatLng, LatLngBounds;
// import 'package:location_repo/location_repo.dart' show LocationRepo, MapsRepo, PolygonLatLng, PolygonModel, Position;
// import 'package:location_repo/location_repo.dart' as location_repo;

part 'maps_state.dart';
// part 'maps_state.g.dart';

class MapsCubit extends Cubit<MapsState> {
  final NotificationService _notificationService;
  final MapsRepo _mapsRepo;

  MapsCubit(
    this._notificationService,
    this._mapsRepo,
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

  List<LatLng> convertPoints(List<LatLng> list) {
    return list;
    // return list.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }

  void addPolygon(String name) async {
    final model = PolygonModel(
      name: name,
      color: state.selectedColor,
      // points: state.latLngs,
      points: convertPoints(state.latLngs),
      id: Random().nextInt(100000000).toString(),
    );
    await _mapsRepo.savePolygon(model);
    _getAllPolygon();
    emit(
      state.copyWith(
        polygons: {
          ...state.polygons,
          PolygonModel(
            id: model.id!,
            name: name,
            points: convertPoints(state.latLngs),
            // type: state.fieldAsset,
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

  void onMarkerDragEnd(LatLng latLng, int index) {
    final latlngs = state.latLngs;
    latlngs[index] = latLng;
    emit(state.copyWith(latLngs: List<LatLng>.from(latlngs)));
  }

  Future<void> updateCurrentLocation() async {
    await controller.future;
    final currentPosition = await GeolocatorService.getCurrentLatLng();
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

  // final _dontVisitProperty = <String>{};
  // Timer? _timer;
  // Timer? _userIsInsidePolygonTimer;
  void getLocationUpdates() {
    // final mapsPopups = MapsPopups(polygonModel);
    final popups = MapsPopups();
    _positionSubscription = GeolocatorService.instance.getPositionStream().listen((event) {
      var position = LatLng(event.latitude, event.longitude);
      final polygonsInCoverage =
          MapsToolkitService.isInsideAccuracy(latLng: position, polygons: state.polygons, accuracy: event.accuracy);
      popups.polygonsInCoverage.add(polygonsInCoverage);
      // state.polygons.forEach((element) async {
      //   final isInsidePolygon = MapsToolkitService.isInsidePolygon(latLng: latLng2, polygon: element.points);
      //   popups.setPolygon(element);
      popups.controller.add(polygonsInCoverage.isNotEmpty);
      // if (isInsidePolygon) {
      //   if (_dontVisitProperty.isNotEmpty) {
      //     if (_dontVisitProperty.contains(element.id)) {
      //       return;
      //     }
      //   }
      //   // if (_userIsInsidePolygonTimer != null) return;
      //   _userIsInsidePolygonTimer = Timer.periodic(2.minutes, (_) {
      //     DialogService.showDialog(child: NotifyManagerDialog());
      //     _dontVisitProperty.clear();
      //   });
      //   if (Get.isDialogOpen ?? false) return;
      //   _timer = Timer(1.minutes, () {
      //     Get.back();
      //   });
      //   final result = await DialogService.showDialog(child: EnterProperty(polygonModel: element));
      //   if (!result) _dontVisitProperty.add(element.id!);
      // }
      // });
    });
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
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
