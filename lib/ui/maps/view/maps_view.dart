import 'dart:developer' as dev;
import 'dart:math';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/features/drawer/view/widgets/drawer_menu_icon.dart';
import 'package:background_location/ui/emergency_warning_page/provider/provider.dart';
import 'package:background_location/ui/maps/cubit/maps_cubit.dart';
import 'package:background_location/ui/maps/location_service/map_toolkit_utils.dart';
import 'package:background_location/ui/maps/location_service/polygons_service.dart';
import 'package:background_location/ui/maps/view/widgets/add_fence.dart';
import 'package:background_location/ui/maps/view/widgets/add_polygon_details.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../gen/assets.gen.dart';
import '../../../widgets/dialogs/dialog_layout.dart';
import '../location_service/geolocator_service.dart';
import '../models/polygon_model.dart';

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
    dev.log(state.name);
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

        break;
      case AppLifecycleState.inactive:
        break;
      default:
    }
  }

  @override
  void initState() {
    cubit = context.read<MapsCubit>();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
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

      await Permission.location.request();
      final result = await GeolocatorService.locationPermission();
      if (result) {
        final result = await Permission.locationAlways.request();
        print(PermissionStatus.values[result.index].name);
        final cubit = context.read<MapsCubit>();
        await cubit.init();
      } else {
        await 3.seconds.delay();
        await DialogService.showDialog(child: const LocationPermissionDialog());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    dev.log('maps view is disposed');
    WidgetsBinding.instance.removeObserver(this);
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
        extendBody: true,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: _buildNavbar(),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CurrentLocation(
              onPressed: cubit.updateCurrentLocation,
            ),
          ],
        ),
        body: Stack(
          children: [
            _buildMapsConsumer(cubit),
            _buildAppbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavbar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Consumer<MapsCubit>(
        builder: (context, cubit, child) {
          final state = cubit.state;
          return MySlideAnimation(
            key: ValueKey(state.addingGeofence),
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
    Widget result = const SizedBox();
    if (state.addingGeofence) {
      result = AddFence(cubit: cubit);
    } else if (state.isEditingFence) {
      result = _showEditSheet(state);
    } else {
      result = _defaultNavbar(state);
    }
    return result;
  }

  Row _defaultNavbar(MapsState state) {
    final allowedRoles = [Roles.producer, Roles.agent, Roles.consignee, Roles.admin];
    final isAllowed = allowedRoles.contains(cubit.userData?.role?.camelCase?.getRole);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        BottomNavbarItem(
          icon: Assets.icons.bottomNavbar.map.path,
          title: 'Map Type',
          onTap: () => DialogService.showDialog(
            child: DialogLayout(child: MapTypeWidget(cubit: cubit)),
          ),
        ),
        if (isAllowed) ...[
          BottomNavbarItem(
            icon: Assets.icons.bottomNavbar.square.path,
            title: 'Add Fencing',
            onTap: cubit.setIsAddingGeofence,
          ),
          BottomNavbarItem(
            iconData: LineIcons.drawPolygon,
            title: 'Locations List',
            onTap: () => BottomSheetService.showSheet(
              padding: EdgeInsets.zero,
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
        ],
        BottomNavbarItem(
          iconData: (Icons.directions_walk_rounded),
          isSelected: state.isTracking,
          color: state.isTracking ? context.theme.primaryColor : null,
          onTap: cubit.toggleTracking,
          title: 'Live Tracking',
        ),
      ],
    );
  }

  Widget _showEditSheet(MapsState state) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomNavbarItem(
            title: 'Select Color',
            iconData: Icons.color_lens,
            onTap: () => BottomSheetService.showSheet(
              child: SelectColor(onColorSelected: cubit.setAssetColor),
            ),
          ),
          BottomNavbarItem(
            title: 'Done',
            iconData: Icons.done,
            onTap: () {
              BottomSheetService.showSheet(
                child: UpdatePolygonDetails(
                  companyOwner: state.currentPolygon?.companyOwner,
                  name: state.currentPolygon?.name,
                  onDone: (name, companyOwnerName) {
                    final polygon = state.currentPolygon!;
                    final updatePolygon = polygon.copyWith(companyOwner: companyOwnerName, name: name);
                    cubit.updatePolygon(updatePolygon);
                    cubit.toggleIsEditingFence();
                    cubit.doneEditing();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Positioned _buildAppbar() {
    return Positioned(
      top: 5.height,
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

  // Widget _buildMaps(MapsCubit cubit) {
  //   return StreamBuilder<List<PolygonModel>>(
  //     stream: cubit.state.isConnected ? cubit.mapsRepoLocal.polygonStream : cubit.mapsRepo.polygonStream,
  //     builder: (context, snapshot) {
  //       return StreamBuilder<List<LatLng>>(
  //         stream: context.read<PolygonsService>().stream,
  //         initialData: const [],
  //         builder: (context, polygonsData) {
  //           return BlocListener<MapsCubit, MapsState>(
  //             listener: _listener,
  //             listenWhen: (previous, current) => previous.insideFence != current.insideFence,
  //             child: BlocBuilder<MapsCubit, MapsState>(
  //               builder: (context, state) {
  //                 return GoogleMap(
  //                   initialCameraPosition: CameraPosition(target: state.currentLocation, zoom: 5),
  //                   onMapCreated: cubit.onMapCreated,
  //                   mapType: state.mapType,
  //                   zoomControlsEnabled: false,
  //                   myLocationButtonEnabled: false,
  //                   onLongPress: (s) => dev.log(s.toString()),
  //                   myLocationEnabled: true,
  //                   polylines: _polylines(state, polygonsData.data ?? []),
  //                   markers: _markers(polygonsData.data ?? [], state.currentLocation),
  //                   polygons: (snapshot.data ?? []).map(addPolygon).toSet(),
  //                   onTap: state.addingGeofence ? (e) => addLatLng(e, state.currentLocation) : null,
  //                 );
  //               },
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Widget _buildMapsConsumer(MapsCubit cubit) {
    return Consumer<MapsCubit>(
      // stream: cubit.state.isConnected ? cubit.mapsRepoLocal.polygonStream : cubit.mapsRepo.polygonStream,
      builder: (context, snapshot, child) {
        final state = snapshot.state;
        // print('rebuilding maps');
        // return StreamBuilder<List<LatLng>>(
        //   stream: context.read<PolygonsService>().stream,
        //   initialData: const [],
        //   builder: (context, polygonsData) {
        //     return BlocListener<MapsCubit, MapsState>(
        //       listener: _listener,
        //       listenWhen: (previous, current) => previous.insideFence != current.insideFence,
        //       child: BlocBuilder<MapsCubit, MapsState>(
        //         builder: (context, state) {
        return GoogleMap(
          initialCameraPosition: CameraPosition(target: state.currentLocation, zoom: 5),
          onMapCreated: cubit.onMapCreated,
          mapType: state.mapType,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          onLongPress: (s) => dev.log(s.toString()),
          polylines: _polylines(state, state.polylines),
          markers: _markers(state.polylines, state.currentLocation),
          polygons: state.polygons.map(addPolygon).toSet(),
          onTap: state.addingGeofence ? (e) => addLatLng(e, state.currentLocation) : null,
        );
        // },
        // ),
        // );
      },
    );
    // },
    // );
  }

  void addLatLng(LatLng latLng, LatLng currentLocation) {
    context.read<PolygonsService>().addLatLng(latLng);
  }

  Set<Marker> _markers(List<LatLng> points, LatLng currentPosition) {
    return points.map(
      (e) {
        final isPolygonClosed = isClosedPolygon(points);
        final polygonService = context.read<PolygonsService>();
        final onTap = isPolygonClosed ? null : () => polygonService.addLatLng(e);
        return Marker(
          markerId: MarkerId(e.toString()),
          flat: false,
          draggable: true,
          onTap: onTap,
          onDragEnd: (p) => polygonService.updateMarkers(p, points.indexOf(e)),
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
  }

  bool isClosedPolygon(List<LatLng> polypoints) {
    final area = MapsToolkitService.isClosedPolygon(_getMtLatLangs(polypoints));

    return area;
  }

  Set<Polyline> _polylines(MapsState state, List<LatLng> points) {
    return {
      Polyline(
        polylineId: PolylineId((Random().nextInt(100000000)).toString()),
        color: state.selectedColor,
        jointType: JointType.bevel,
        patterns: const [PatternItem.dot],
        width: 2.width.toInt(),
        points: points,
      ),
    };
  }

  // void _listener(BuildContext context, MapsState state) {}

  Widget _buildBackButton() {
    return Container(
      padding: EdgeInsets.only(left: widget.fromDrawer ? 0 : 8),
      decoration:
          MyDecoration.decoration(isCircle: true, color: const Color.fromARGB(26, 255, 255, 255).withOpacity(.71)),
      child: widget.fromDrawer
          ? const DrawerMenuIcon()
          : IconButton(
              onPressed: goBack,
              icon: const Icon(Icons.arrow_back_ios),
            ),
    );
  }

  void goBack() {
    Get.back();
    Get.back();
  }
}
