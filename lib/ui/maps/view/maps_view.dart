import 'dart:math';

import 'package:background_location/constants/constans.dart';
import 'package:background_location/constants/my_decoration.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/ui/maps/cubit/maps_cubit.dart';
import 'package:background_location/ui/maps/models/enums/filed_assets.dart';
import 'package:background_location/ui/maps/view/widgets/current_location.dart';
import 'package:background_location/ui/maps/view/widgets/maps_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends StatefulWidget {
  const MapsView({Key? key}) : super(key: key);

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      Permission.location.request().then((value) {
        if (value.isGranted) {
          final cubit = context.read<MapsCubit>();
          cubit.init();
        }
      });
    });
    super.initState();
  }

  // @override
  // void dispose() {
  //   context.read<MapsCubit>().close();
  //   super.dispose();
  // }

  void showSnackbar(String text) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapsCubit>();
    return Scaffold(
      // extendBodyBehindAppBar: true,
      extendBody: false,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: MapsBottomNavbar(cubit: cubit),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // _addGeofence(cubit),
          CurrentLocation(onPressed: cubit.updateCurrentLocation),
          // FloatingActionButton(
          //   onPressed: cubit.updateCurrentLocation,
          //   backgroundColor: Colors.white,
          //   child: Icon(
          //     Icons.my_location,
          //     color: Colors.black,
          //   ),
          // ),
          Gap(10.height),
        ],
      ),
      // appBar: MyAppBar(
      //   title: const Text('Maps'),
      //   // backgroundColor: Colors.transparent,
      // ),
      body: Stack(
        children: [
          _buildMaps(cubit),
          _buildAppbar(),
        ],
      ),
    );
  }

  Positioned _buildAppbar() {
    return Positioned(
      top: 5.height,
      // width: 100.height,
      child: Container(
        width: 100.width,
        padding: kPadding,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBackButton(),
            // Spacer(),
            // _buildMapTypeButton(),
          ],
        ),
      ),
    );
  }

  // FloatingActionButton _addGeofence(MapsCubit cubit) {
  //   return FloatingActionButton(
  //     backgroundColor: Colors.white,
  //     heroTag: 'addGeofence',
  //     onPressed: cubit.zoom,
  //     child: BlocBuilder<MapsCubit, MapsState>(
  //       builder: (context, state) {
  //         return Icon(
  //           state.addingGeofence ? Icons.check : Icons.add,
  //           color: Colors.black,
  //         );
  //       },
  //     ),
  //   );
  // }

  BlocListener<MapsCubit, MapsState> _buildMaps(MapsCubit cubit) {
    return BlocListener<MapsCubit, MapsState>(
      listener: _listener,
      child: BlocBuilder<MapsCubit, MapsState>(
        builder: (context, state) {
          return GoogleMap(
            initialCameraPosition: CameraPosition(target: state.currentLocation, zoom: 20),
            onMapCreated: cubit.onMapCreated,
            // mapToolbarEnabled: true,

            mapType: state.mapType,
            zoomControlsEnabled: true,
            // tiltGesturesEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            polylines: _polylines(state),
            markers: _markers(state),
            // circles: _circles(state),
            polygons: state.polygons
                .map(
                  (e) => addPolygon(
                    e.points,
                    e.type.color,
                  ),
                )
                .toSet(),
            onTap: state.addingGeofence ? cubit.addLatLng : null,
          );
        },
      ),
    );
  }

  Set<Marker> _markers(MapsState state) {
    return state.latLngs
        .map(
          (e) => Marker(
            // anchor: ,
            markerId: MarkerId(e.toString()),
            draggable: true,
            onDragEnd: (p) =>  context.read<MapsCubit>().onMarkerDragEnd(p, state.latLngs.indexOf(e)),
            position: e,
            consumeTapEvents: true,
          ),
        )
        .toSet();
  }

  Polygon addPolygon(List<LatLng> latLngs, Color color) {
    final polygonId = PolygonId(Random().nextInt(100000000).toString());
    return Polygon(
      polygonId: polygonId,
      points: latLngs,
      strokeWidth: 5,
      strokeColor: color,
      fillColor: color.withOpacity(0.15),
    );
  }

  Set<Polyline> _polylines(MapsState state) {
    return {
      Polyline(
        polylineId: PolylineId((Random().nextInt(100000000)).toString()),
        // color: Color.fromARGB(255, 249, 48, 33),
        color: state.fieldAsset.color,
        jointType: JointType.round,
        startCap: Cap.buttCap,
        patterns: [PatternItem.dot],
        visible: true,
        width: 10,
        points: state.latLngs,
      ),
    };
  }

  // Set<Circle> _circles(MapsState state) {
  //   return {
  //     Circle(
  //       circleId: CircleId('kldsj'),
  //       center: state.currentLocation,
  //       radius: 40,
  //       strokeColor: Colors.blue,
  //       strokeWidth: 2,
  //       fillColor: Colors.blue.withOpacity(0.1),
  //     )
  //   };
  // }

  void _listener(context, state) {
    // state.insideFence
    //     ? showSnackbar('User is inside the fence')
    //     : showSnackbar('User is outside the fence');
  }

  // Widget _buildMapTypeButton() {
  //   return MapTypeWidget(
  //     onPressed: context.read<MapsCubit>().changeMapType,
  //   );
  // }

  Widget _buildBackButton() {
    return Container(
      padding: EdgeInsets.only(left: 8),
      decoration: MyDecoration.decoration(isCircle: true, color: Colors.white.withOpacity(1)),
      child: IconButton(
        onPressed: Get.back,
        icon: Icon(Icons.arrow_back_ios),
      ),
    );
  }
}
