import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/select_role/view/select_role_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ui/admin/view/admin_page.dart';
import '../../../ui/login/view/login_page.dart';
import '../../../ui/maps/view/maps_page.dart';
import '../../../ui/settings/view/settings_page.dart';
import 'drawer_item.dart';

class DrawerItems {
  final Api api;
  late List<DrawerItem> items;
  DrawerItems(this.api) {
    items = [
      DrawerItem(
        text: Strings.home,
        iconData: Icons.home,
        page: SelectRolePage(),
      ),
      DrawerItem(
        text: Strings.admin,
        iconData: Icons.admin_panel_settings_outlined,
        page: AdminPage(),
      ),
      if (api.getUserData() != null)
        DrawerItem(
          text: Strings.map,
          iconData: Icons.map,
          page: MapsPage(fromDrawer: true),
        ),
      DrawerItem(
        text: Strings.settings,
        iconData: Icons.settings,
        page: SettingsPage(),
      ),
      DrawerItem(
        onTap: () {
          api.logout();
          Get.offAll(() => LoginPage());
        },
        text: Strings.logout,
        iconData: Icons.logout,
        page: LoginPage(),
      ),
    ];
  }
  // items = [ DrawerItem(
  //   text: Strings.home,
  //   iconData: Icons.home,
  //   page: SelectRolePage(),
  // ),
  // DrawerItem(
  //   text: Strings.map,
  //   iconData: Icons.map,
  //   page: MapsPage(),
  // ),
  // DrawerItem(
  //   text: Strings.settings,
  //   iconData: Icons.settings,
  //   page: SettingsPage(),
  // ),
  // DrawerItem(
  //   onTap: () => api
  //   text: Strings.logout,
  //   iconData: Icons.logout,
  //   page: LoginPage(),
  // ),
  // ];
  // }

  // final items = [
  //   DrawerItem(
  //     text: Strings.home,
  //     iconData: Icons.home,
  //     page: SelectRolePage(),
  //   ),
  //   DrawerItem(
  //     text: Strings.map,
  //     iconData: Icons.map,
  //     page: MapsPage(),
  //   ),
  //   DrawerItem(
  //     text: Strings.settings,
  //     iconData: Icons.settings,
  //     page: SettingsPage(),
  //   ),
  //   DrawerItem(
  //     onTap: () => api.logout();
  //     text: Strings.logout,
  //     iconData: Icons.logout,
  //     page: LoginPage(),
  //   ),
  // ];
}
