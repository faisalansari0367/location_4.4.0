import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/features/bottom_navbar/view/navbar_page.dart';
import 'package:bioplus/features/drawer/cubit/my_drawer_controller.dart';
import 'package:flutter/material.dart';

import '../../../ui/admin/view/admin_page.dart';
import '../../../ui/settings/view/settings_page.dart';
import 'drawer_item.dart';

class DrawerItems {
  final Api api;
  late List<DrawerItem> items;
  final DrawerCubit drawer;
  DrawerItems(this.api, {required this.drawer}) {
    items = _getItems;
  }

  List<DrawerItem> get _getItems {
    final userData = api.getUser();
    final isAdmin = userData?.role?.toLowerCase() == 'admin';
    // final isAdmin = true;
    return [
      // if (!isAdmin)
      const DrawerItem(
        text: 'Dashboard',
        iconData: Icons.dashboard,
        page: NavbarPage(),
      ),
      if (isAdmin)
        const DrawerItem(
          text: Strings.admin,
          iconData: Icons.admin_panel_settings_outlined,
          page: AdminPage(),
        ),
      const DrawerItem(
        text: Strings.settings,
        iconData: Icons.settings,
        page: SettingsPage(),
      ),
    ];
  }
}
