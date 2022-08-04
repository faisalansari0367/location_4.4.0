import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  MapsCubit() : super(MapsInitial());

  Completer<GoogleMapController> controller = Completer();

  final CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final CameraPosition kLake = CameraPosition(
    target: const LatLng(20.5937, 78.9629),
    // tilt: 59.440717697143555,
    zoom: 4.151926040649414,
  );

  void onMapCreated(GoogleMapController controller) {
    this.controller.complete(controller);
  }
}
