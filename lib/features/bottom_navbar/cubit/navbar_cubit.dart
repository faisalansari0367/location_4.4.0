import 'package:bioplus/ui/dashboard/dashboard.dart';
import 'package:bioplus/ui/scan_qr/scan_qr.dart';
import 'package:bioplus/ui/select_role/view/select_role_page.dart';
import 'package:bioplus/ui/settings/view/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navbar_state.dart';

class NavbarCubit extends Cubit<NavbarState> {
  NavbarCubit() : super(const NavbarState());

  static const _items = [
    DashboardPage(),
    ScanQrPage(),
    // AdminPage(),
    SelectRolePage(),
    // MapsPage(),

    SettingsPage(),
    // SettingsPage()
  ];

  void updateIndex(int index) {
    final reverse = index < state.index;
    emit(state.copyWith(reverse: reverse, index: index));
  }

  Widget get currentPage => _items.elementAt(state.index);
}
