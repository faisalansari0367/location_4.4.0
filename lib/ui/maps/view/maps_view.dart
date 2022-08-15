import 'dart:math';

import 'package:background_location/constants/index.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/features/drawer/view/widgets/drawer_menu_icon.dart';
import 'package:background_location/ui/maps/cubit/maps_cubit.dart';
import 'package:background_location/ui/maps/location_service/map_toolkit_utils.dart';
import 'package:background_location/ui/maps/view/widgets/current_location.dart';
import 'package:background_location/ui/maps/view/widgets/maps_bottom_nav_bar.dart';
import 'package:background_location/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_notification/local_notification.dart';
// import 'package:location_repo/location_repo.dart' as location_repo;
import 'package:permission_handler/permission_handler.dart';

import '../location_service/maps_repo.dart';
import '../models/polygon_model.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends StatefulWidget {
  final bool fromDrawer;
  const MapsView({Key? key, this.fromDrawer = false}) : super(key: key);

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final cubit = context.read<MapsCubit>();
    final stream = context.read<MapsRepo>().polygonStream;
    // stream.
    switch (state) {
      case AppLifecycleState.detached:
        print('AppLifecycleState.detached');
        break;
      case AppLifecycleState.resumed:
        print('AppLifecycleState.resumed');
        final controller = await cubit.controller.future;
        cubit.onMapCreated(controller);
        break;
      case AppLifecycleState.paused:
        print('AppLifecycleState.paused');
        // handleInactiveState();
        break;
      case AppLifecycleState.inactive:
        // log(state.toString());
        break;
      default:
      // log(state.toString());
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
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

  @override
  void dispose() {
    // context.read<MapsCubit>().close();

    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  void showSnackbar(String text) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapsCubit>();
    return WillPopScope(
      onWillPop: () async {
        goBack();
        return true;
      },
      child: Scaffold(
        extendBody: false,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: MapsBottomNavbar(cubit: cubit),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // _addGeofence(cubit),
            CurrentLocation(
              onPressed: cubit.updateCurrentLocation,
            ),
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

  Widget _buildMaps(MapsCubit cubit) {
    return StreamBuilder<List<PolygonModel>>(
        stream: context.read<MapsRepo>().polygonStream,
        builder: (context, snapshot) {
          print(snapshot.data);
          return BlocListener<MapsCubit, MapsState>(
            listener: _listener,
            listenWhen: (previous, current) => previous.insideFence != current.insideFence,
            child: BlocBuilder<MapsCubit, MapsState>(
              builder: (context, state) {
                return GoogleMap(
                  initialCameraPosition: CameraPosition(target: state.currentLocation, zoom: 5),
                  onMapCreated: cubit.onMapCreated,
                  mapType: state.mapType,
                  zoomControlsEnabled: true,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  polylines: _polylines(state),
                  markers: _markers(state),
                  polygons: (snapshot.data ?? []).map((e) => addPolygon(e)).toSet(),
                  onTap: state.addingGeofence ? cubit.addLatLng : null,
                  // mapToolbarEnabled: true,
                  // tiltGesturesEnabled: false,
                  // circles: _circles(state),
                );
              },
            ),
          );
        });
  }

  Set<Marker> _markers(MapsState state) {
    return state.latLngs.map(
      (e) {
        final isPolygonClosed = isClosedPolygon(state.latLngs);
        final onTap = isPolygonClosed ? null : () => context.read<MapsCubit>().addLatLng(e);
        return Marker(
          markerId: MarkerId(e.toString()),
          flat: true,
          draggable: true,
          onTap: onTap,
          onDragEnd: (p) => context.read<MapsCubit>().onMarkerDragEnd(p, state.latLngs.indexOf(e)),
          position: e,
          consumeTapEvents: isPolygonClosed,
        );
      },
    ).toSet();
  }

  Polygon addPolygon(PolygonModel data) {
    final polygonId = PolygonId(data.id!);
    final latLngs = data.points;
    final color = data.color;
    final name = data.name;
    return Polygon(
      polygonId: polygonId,
      points: latLngs,
      strokeWidth: 5,
      strokeColor: color,
      fillColor: color.withOpacity(0.15),
      consumeTapEvents: true,
      onTap: () {
        BottomSheetService.showSheet(
          child: Padding(
            // padding: EdgeInsets.symmetric(horizontal: 5.width),
            padding: EdgeInsets.only(
              left: 5.width,
              right: 5.width,
              bottom: context.mediaQueryViewPadding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Field Details',
                  style: context.textTheme.headline6?.copyWith(
                      // fontWeight: FontWeight.w600,
                      ),
                ),
                Gap(2.height),
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Field Name',
                      style: context.textTheme.subtitle2?.copyWith(
                          // fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      name,
                      style: context.textTheme.subtitle2?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Field Area',
                      style: context.textTheme.subtitle2?.copyWith(
                          // fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '${getPolygonArea(latLngs).toStringAsFixed(2)} m2',
                      style: context.textTheme.subtitle2?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      // visible: false,

      // geodesic: true,
    );
  }

  List<LatLng> _getMtLatLangs(List<LatLng> polypoints) {
    return polypoints;
    // return polypoints.map((e) => PolygonLatLng(e.latitude, e.longitude)).toList();
  }

  num getPolygonArea(List<LatLng> polypoints) {
    // final points = _getMtLatLangs(polypoints);
    final area = MapsToolkitService.calculatePolygonArea(polypoints);
    return area;
  }

  bool isClosedPolygon(List<LatLng> polypoints) {
    final area = MapsToolkitService.isClosedPolygon(_getMtLatLangs(polypoints));
    // print('is closed polygon: $area');
    return area;
  }

  Set<Polyline> _polylines(MapsState state) {
    return {
      Polyline(
        polylineId: PolylineId((Random().nextInt(100000000)).toString()),
        // color: Color.fromARGB(255, 249, 48, 33),
        color: state.selectedColor,
        jointType: JointType.bevel,
        startCap: Cap.buttCap,
        patterns: [PatternItem.dot],

        // visible: true,
        // geodesic: ,
        width: 2.width.toInt(),
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

  void _listener(BuildContext context, MapsState state) {
    final location = state.insideFence ? 'inside' : 'outside';
    // if (!state.insideFence) return;
    context.read<NotificationService>().showNotification(
          id: state.insideFence ? 1 : 2,
          title: Strings.appName,
          message: 'You are $location the ${state.currentPolygon?.name} fence',
        );
  }

  // Widget _buildMapTypeButton() {
  //   return MapTypeWidget(
  //     onPressed: context.read<MapsCubit>().changeMapType,
  //   );
  // }

  Widget _buildBackButton() {
    return Container(
      padding: EdgeInsets.only(left: widget.fromDrawer ? 0 : 8),
      decoration: MyDecoration.decoration(isCircle: true, color: Color.fromARGB(26, 255, 255, 255).withOpacity(.71)),
      child: widget.fromDrawer
          ? DrawerMenuIcon()
          : IconButton(
              onPressed: goBack,
              icon: Icon(Icons.arrow_back_ios),
            ),
    );
  }

  void goBack() {
    Get.back();
    Get.back();
  }
}
