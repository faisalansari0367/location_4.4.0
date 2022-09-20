import 'dart:math';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/features/drawer/view/widgets/drawer_menu_icon.dart';
import 'package:background_location/ui/maps/cubit/maps_cubit.dart';
import 'package:background_location/ui/maps/location_service/map_toolkit_utils.dart';
import 'package:background_location/ui/maps/location_service/polygons_service.dart';
import 'package:background_location/ui/maps/view/widgets/add_fence.dart';
import 'package:background_location/ui/maps/view/widgets/current_location.dart';
import 'package:background_location/ui/maps/view/widgets/dialog/polygon_details.dart';
import 'package:background_location/ui/maps/view/widgets/map_type_widget.dart';
import 'package:background_location/ui/maps/view/widgets/select_color.dart';
import 'package:background_location/ui/maps/widgets/geofences_list/geofences_view.dart';
import 'package:background_location/widgets/animations/my_slide_animation.dart';
import 'package:background_location/widgets/bottom_navbar/bottom_navbar_item.dart';
import 'package:background_location/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:background_location/widgets/dialogs/error.dart';
import 'package:background_location/widgets/dialogs/location_permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:location_repo/location_repo.dart' as location_repo;

import '../../../gen/assets.gen.dart';
import '../../../widgets/dialogs/dialog_layout.dart';
import '../location_service/geolocator_service.dart';
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
  late MapsCubit cubit;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // final stream = context.read<MapsRepo>().polygonStream;
    // final cubit = context.read<MapsCubit>();

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
    cubit = context.read<MapsCubit>();
    WidgetsBinding.instance?.addObserver(this);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      final api = context.read<Api>();
      final userData = api.getUserData();
      if (userData == null) {
        await DialogService.showDialog(
          child: ErrorDialog(
            message: 'Please select a role and come back again',
            buttonText: 'Go back',
            onTap: () {
              Get.back();
              Get.back();
            },
          ),
        );
      }
      // _handlePermission();
      await Permission.location.request();
      final result = await GeolocatorService.locationPermission();
      print('result $result');

      // await GeolocatorService.locationPermission();
      // print(status.isGranted);
      if (result) {
        // final status = await Permission.location.status;
        // if(status == PermissionStatus.)
        final result = await Permission.locationAlways.request();
        print(PermissionStatus.values[result.index].name);
        final cubit = context.read<MapsCubit>();
        cubit.init();
      } else {
        await 3.seconds.delay();
        DialogService.showDialog(child: LocationPermissionDialog());
      }

      // Permission.location.request().then((value) async {
      //   if (value.isGranted) {
      // });
    });
    super.initState();
  }

  // void _handlePermission() async {
  //   var status = await Permission.locationWhenInUse.status;
  //   if (!status.isGranted) {
  //     var status = await Permission.locationWhenInUse.request();
  //     if (status.isGranted) {
  //       var status = await Permission.locationAlways.request();
  //       if (status.isGranted) {
  //         final cubit = context.read<MapsCubit>();
  //         cubit.init();
  //         //Do some stuff
  //       } else {
  //         await 3.seconds.delay();
  //         DialogService.showDialog(child: LocationPermissionDialog());
  //         //Do another stuff
  //       }
  //     } else {
  //       await 3.seconds.delay();
  //       DialogService.showDialog(child: LocationPermissionDialog());
  //       //The user deny the permission
  //     }
  //     if (status.isPermanentlyDenied) {
  //       //When the user previously rejected the permission and select never ask again
  //       //Open the screen of settings
  //       await 3.seconds.delay();
  //       await DialogService.showDialog(child: LocationPermissionDialog());
  //       // bool res = await openAppSettings();
  //     }
  //   } else {
  //     //In use is available, check the always in use
  //     var status = await Permission.locationAlways.status;
  //     if (!status.isGranted) {
  //       var status = await Permission.locationAlways.request();
  //       if (status.isGranted) {
  //         final cubit = context.read<MapsCubit>();
  //         cubit.init();
  //         //Do some stuff
  //       } else {
  //         await 3.seconds.delay();
  //         DialogService.showDialog(child: LocationPermissionDialog());
  //         //Do another stuff
  //       }
  //     } else {
  //       //previously available, do some stuff or nothing
  //     }
  //   }
  // }

  @override
  void dispose() {
    // context.read<MapsRepo>().cancel();

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
    // cubit.updateCurrentLocation();
    return WillPopScope(
      onWillPop: () async {
        goBack();
        return true;
      },
      child: Scaffold(
        // bottomSheet: Container(),
        extendBody: true,
        backgroundColor: Colors.transparent,
        // bottomNavigationBar: MapsBottomNavbar(cubit: cubit),
        bottomNavigationBar: _buildNavbar(),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // _addGeofence(cubit),
            CurrentLocation(
              onPressed: cubit.updateCurrentLocation,
            ),
            Gap(10.h),

            FloatingActionButton(
              onPressed: () => cubit.zoom(2),
              backgroundColor: Colors.white,
              heroTag: 'zoom_plus',
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
            Gap(10.h),
            FloatingActionButton(
              heroTag: 'zoom_minus',
              onPressed: () => cubit.zoom(-2),
              backgroundColor: Colors.white,
              child: Icon(
                Icons.remove,
                color: Colors.black,
              ),
            ),
            // if (Platform.isAndroid) Gap(10.height),
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
            // Positioned(
            //   bottom: 0,
            //   child: _buildNavbar(),
            // ),
            // _showEditSheet(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavbar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: BlocBuilder<MapsCubit, MapsState>(
        builder: (context, state) {
          return MySlideAnimation(
            duration: kDuration,
            key: ValueKey(state.addingGeofence),
            // child: state.addingGeofence ? AddFence(cubit: cubit) : _normalNavbar(),
            child: Container(
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.only(bottom: min(context.mediaQueryViewPadding.bottom, 15.h)),
              decoration: MyDecoration.bottomSheetDecoration(),
              child: _getWidget(state),
            ),
          );
        },
      ),
    );
  }

  Widget _getWidget(MapsState state) {
    Widget result = SizedBox();
    if (state.addingGeofence) {
      result = AddFence(cubit: cubit);
    } else if (state.isEditingFence) {
      result = _showEditSheet();
    } else {
      result = _defaultNavbar();
    }
    return result;
  }

  Row _defaultNavbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        BottomNavbarItem(
          icon: Assets.icons.bottomNavbar.map.path,
          title: ('Map Type'),
          onTap: () => DialogService.showDialog(
            child: DialogLayout(child: MapTypeWidget(cubit: cubit)),
          ),
        ),
        if ([Roles.producer, Roles.agent, Roles.consignee].contains(cubit.userData?.role?.camelCase?.getRole))
          BottomNavbarItem(
            icon: Assets.icons.bottomNavbar.square.path,
            title: ('Add Fencing'),
            onTap: cubit.setIsAddingGeofence,
          ),

        // if ([Roles.producer, Roles.agent, Roles.consignee].contains(cubit.userData?.role?.camelCase?.getRole))
        BottomNavbarItem(
          iconData: LineIcons.drawPolygon,
          title: ('Geofence List'),
          onTap: () => BottomSheetService.showSheet(
            child: DraggableScrollableSheet(
              maxChildSize: 0.9,
              expand: false,
              minChildSize: 0.2,
              initialChildSize: 0.4,
              builder: (context, scrollController) {
                return GeofencesList(
                  onSelected: (value) {
                    cubit.moveToSelectedPolygon(value);
                    Get.back();
                  },
                  controller: scrollController,
                );
              },
            ),
          ),
        ),
        // Spacer(),
      ],
    );
  }

  Widget _showEditSheet() {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      // width: 100.width,
      // height: 6.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomNavbarItem(
            title: 'Select Color',
            iconData: Icons.color_lens,
            onTap: () => BottomSheetService.showSheet(child: SelectColor(cubit: cubit)),
          ),
          BottomNavbarItem(
            title: 'Done',
            iconData: Icons.done,
            onTap: () => cubit.doneEditing(),
          ),
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
          children: [
            _buildBackButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMaps(MapsCubit cubit) {
    // final _polygonsService = context.read<PolygonsService>();
    return StreamBuilder<List<PolygonModel>>(
      stream: context.read<MapsRepo>().polygonStream,
      builder: (context, snapshot) {
        return StreamBuilder<List<LatLng>>(
          stream: context.read<PolygonsService>().stream,
          initialData: [],
          builder: (context, polygonsData) {
            return BlocListener<MapsCubit, MapsState>(
              listener: _listener,
              listenWhen: (previous, current) => previous.insideFence != current.insideFence,
              child: BlocBuilder<MapsCubit, MapsState>(
                builder: (context, state) {
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(target: state.currentLocation, zoom: 5),
                    onMapCreated: cubit.onMapCreated,
                    mapType: state.mapType,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    polylines: _polylines(state, polygonsData.data ?? []),
                    markers: _markers(polygonsData.data ?? [], state.currentLocation),
                    polygons: (snapshot.data ?? []).map((e) => addPolygon(e)).toSet(),
                    onTap: state.addingGeofence ? (e) => addLatLng(e, state.currentLocation) : null,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  void addLatLng(LatLng latLng, LatLng currentLocation) {
    final distance = MapsToolkitService.distance(currentLocation, latLng);
    print(distance);
    if (distance > 50000) {
      Get.snackbar(
        'Can not add fence',
        'Fences can only be added inside 50km from current location. You are currently at ${(distance / 1000).toStringAsFixed(1)}km',
        backgroundColor: Colors.white.withAlpha(100),
      );
      return;
    }
    context.read<PolygonsService>().addLatLng(latLng);
  }

  Set<Marker> _markers(List<LatLng> points, LatLng currentPosition) {
    return points.map(
      (e) {
        final isPolygonClosed = isClosedPolygon(points);
        final onTap = isPolygonClosed ? null : () => context.read<PolygonsService>().addLatLng(e);
        return Marker(
          markerId: MarkerId(e.toString()),
          flat: true,
          draggable: true,
          onTap: onTap,
          onDragEnd: (p) => context.read<PolygonsService>().updateMarkers(p, points.indexOf(e)),
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
    return Polygon(
      polygonId: polygonId,
      points: latLngs,
      strokeWidth: 5,
      strokeColor: color,
      fillColor: color.withOpacity(0.15),
      consumeTapEvents: true,
      onTap: () {
        BottomSheetService.showSheet(
          child: PolygonDetails(
            polygonModel: data,
            canEdit: cubit.canUserEdit(data.createdBy!.id!),
            onTap: () {
              cubit.startEditPolygon(data);
              Get.back();
            },
          ),
        );
      },
    );
  }

  List<LatLng> _getMtLatLangs(List<LatLng> polypoints) {
    return polypoints;
    // return polypoints.map((e) => PolygonLatLng(e.latitude, e.longitude)).toList();
  }

  // num getPolygonArea(List<LatLng> polypoints) {
  //   // final points = _getMtLatLangs(polypoints);
  //   final area = MapsToolkitService.calculatePolygonArea(polypoints);
  //   return area;
  // }

  bool isClosedPolygon(List<LatLng> polypoints) {
    final area = MapsToolkitService.isClosedPolygon(_getMtLatLangs(polypoints));
    // print('is closed polygon: $area');
    return area;
  }

  Set<Polyline> _polylines(MapsState state, List<LatLng> points) {
    return {
      Polyline(
        polylineId: PolylineId((Random().nextInt(100000000)).toString()),
        color: state.selectedColor,
        jointType: JointType.bevel,
        startCap: Cap.buttCap,
        patterns: [PatternItem.dot],
        width: 2.width.toInt(),
        points: points,
      ),
    };
  }

  void _listener(BuildContext context, MapsState state) {
    // final location = state.insideFence ? 'inside' : 'outside';

    // if (!state.insideFence) return;
    // context.read<NotificationService>().showNotification(
    //       id: state.insideFence ? 1 : 2,
    //       title: Strings.appName,
    //       message: 'You are $location the ${state.currentPolygon?.name} fence',
    //     );
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
