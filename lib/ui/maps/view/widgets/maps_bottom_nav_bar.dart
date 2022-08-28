import 'dart:io';
import 'dart:math';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/gen/assets.gen.dart';
import 'package:background_location/ui/maps/cubit/maps_cubit.dart';
import 'package:background_location/ui/maps/view/widgets/add_fence.dart';
import 'package:background_location/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:background_location/widgets/bottom_navbar/bottom_navbar_item.dart';
import 'package:background_location/widgets/dialogs/dialog_layout.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'map_type_widget.dart';

class MapsBottomNavbar extends StatefulWidget {
  final MapsCubit cubit;
  const MapsBottomNavbar({Key? key, required this.cubit}) : super(key: key);

  @override
  State<MapsBottomNavbar> createState() => _MapsBottomNavbarState();
}

class _MapsBottomNavbarState extends State<MapsBottomNavbar> {
  static final icons = Assets.icons.bottomNavbar;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: kBorderRadius,
      ),
      child: BlocProvider.value(
        value: widget.cubit,
        child: BlocBuilder<MapsCubit, MapsState>(
          buildWhen: (previous, current) => previous.addingGeofence != current.addingGeofence,
          builder: (context, state) {
            return Container(
              constraints: BoxConstraints(maxHeight: 110.h),
              height: height,
              child: Stack(
                children: [
                  _positioned(
                    left: state.addingGeofence ? -100.width : 0,
                    child: _bottomNavbar(),
                  ),
                  _positioned(
                    left: state.addingGeofence ? 0 : 100.width,
                    child: AddFence(cubit: widget.cubit),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  double get height {
    const _kHeight = 60;
    final padding = MediaQuery.of(context).viewPadding.bottom;
    final bottomPadding = Platform.isIOS ? min(padding, 20) : padding;
    return (_kHeight + bottomPadding).toDouble();
  }

  AnimatedPositioned _positioned({double? left = 0, required Widget child}) {
    return AnimatedPositioned(
      left: left,
      curve: Curves.easeInOut,
      duration: 175.milliseconds,
      child: SizedBox(
        child: child,
        width: 100.width,
      ),
    );
  }

  Widget _bottomNavbar() {
    final userData = context.read<Api>().getUserData();

    return BottomNavbar(
      color: Colors.transparent,
      items: [
        BottomNavbarItem(
          icon: icons.map.path,
          title: ('Map Type'),
          onTap: () => DialogService.showDialog(
            child: DialogLayout(child: MapTypeWidget(cubit: widget.cubit)),
          ),
        ),
        if ([Roles.producer, Roles.agent, Roles.consignee].contains(userData!.role!.camelCase!.getRole))
          BottomNavbarItem(
            icon: icons.square.path,
            title: ('Add Fencing'),
            onTap: widget.cubit.setIsAddingGeofence,
          ),
      ],
    );
  }
}
