import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/gen/assets.gen.dart';
import 'package:background_location/ui/maps/cubit/maps_cubit.dart';
import 'package:background_location/ui/maps/models/enums/filed_assets.dart';
import 'package:background_location/widgets/bottom_navbar/bottom_navbar.dart';
import 'package:background_location/widgets/bottom_navbar/bottom_navbar_item.dart';
import 'package:background_location/widgets/dialogs/dialog_layout.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'map_type_widget.dart';
import 'select_color.dart';

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
      color: Colors.white,
      child: BlocProvider.value(
        value: widget.cubit,
        child: BlocBuilder<MapsCubit, MapsState>(
          buildWhen: (previous, current) => previous.addingGeofence != current.addingGeofence,
          builder: (context, state) {
            return Container(
              constraints: BoxConstraints(maxHeight: 100),
              height: 8.height,
              child: Stack(
                children: [
                  _positioned(
                    left: state.addingGeofence ? -100.width : 0,
                    child: _bottomNavbar(),
                  ),
                  _positioned(
                    left: state.addingGeofence ? 0 : 100.width,
                    child: addingFence(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AnimatedPositioned _positioned({double? left = 0, required Widget child}) {
    return AnimatedPositioned(
      left: left,
      curve: Curves.easeInOut,
      duration: 175.milliseconds,
      child: SizedBox(
        child: child,
        width: 100.width,
        height: 8.height,
      ),
    );
  }

  Widget _bottomNavbar() {
    // return BlocBuilder<MapsCubit, MapsState>(
    //   builder: (context, state) {
    return BottomNavbar(
      items: [
        BottomNavbarItem(
          icon: icons.map.path,
          title: ('Map Type'),
          onTap: () => DialogService.showDialog(
            child: DialogLayout(child: MapTypeWidget(cubit: widget.cubit)),
          ),
        ),
        // BottomNavbarItem(
        //   icon: icons.colorPicker.path,
        //   title: ('Select color'),
        //   // isSelected: ,
        //   color: state.fieldAsset.color,
        //   onTap: () => DialogService.showDialog(
        //     child: SelectColor(cubit: widget.cubit),
        //   ),
        // ),
        BottomNavbarItem(
          icon: icons.square.path,
          title: ('Add Fencing'),
          onTap: widget.cubit.setIsAddingGeofence,
        ),
      ],
    );
    //   },
    // );
  }

  Widget addingFence() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              'Tap on the screen to draw fence',
              style: context.textTheme.subtitle2,
            ),
          ),
        ),
        _selectColorWidget(),
        // Divider(),
        Container(
          width: 0.5.width,
          height: 7.height,
          color: Color.fromARGB(58, 0, 0, 0),
        ),
        Flexible(
          flex: 1,
          child: Center(
            child: GestureDetector(
              onTap: widget.cubit.setIsAddingGeofence,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check),
                  Text('done'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _selectColorWidget() {
    return BlocBuilder<MapsCubit, MapsState>(
      builder: (context, state) => BottomNavbarItem(
        icon: icons.colorPicker.path,
        title: ('Select color'),
        // isSelected: ,
        color: state.fieldAsset.color,
        onTap: () => DialogService.showDialog(
          child: DialogLayout(child: SelectColor(cubit: widget.cubit)),
        ),
      ),
    );
  }
}
