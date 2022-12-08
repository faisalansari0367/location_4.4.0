import 'package:bioplus/features/drawer/cubit/my_drawer_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerMenuIcon extends StatelessWidget {
  final Color? iconColor;

  // final Animation<double> controller;

  const DrawerMenuIcon({Key? key, this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drawer = Provider.of<DrawerCubit>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.all(0),
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () => _onPressedIcon(context),
        padding: EdgeInsets.zero,
        icon: AnimatedIcon(
          color: iconColor ?? Colors.black,
          icon: AnimatedIcons.menu_close,
          progress: drawer.controller,
        ),
      ),
    );
  }

  void _onPressedIcon(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final drawer = Provider.of<DrawerCubit>(context, listen: false);
    drawer.isOpen ? drawer.closeDrawer() : drawer.openDrawer();
  }
}
