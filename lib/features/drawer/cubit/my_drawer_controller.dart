import 'package:api_repo/api_repo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import '../models/drawer_items.dart';

// import 'drawer_items.dart';

class DrawerCubit extends ChangeNotifier {
  final Api api;
  DrawerCubit(this.api);

  late AnimationController controller;
  bool isOpen = false;
  // final _drawerItems = DrawerItems().items;
  int selectedIndex = 0;
  // var selectedPage = drawerItems.first.page;
  DateTime? _currentBackPressTime;
  // final _drawerItems = DrawerItems.defaultItems;

  // List<DrawerItem> get drawerItems => _drawerItems;

  void setSelectedPage(int page) {
    if (page == selectedIndex) return;
    selectedIndex = page;
    // notifyListeners();
    closeDrawer();
  }

  // void setSelected(int index) {
  //   selectedIndex = index;
  //   closeDrawer();
  // }

  // pass the name
  // void push(String title) {
  //   final items = DrawerItems.defaultItems;
  //   final item = items.firstWhere((element) => element.title.toString().toLowerCase() == title.toLowerCase());
  //   final index = item.page;
  //   // selectedIndex = index;
  //   // notifyListeners();
  //   setSelectedPage(index);
  // }

  Future<bool> _onGoBackTwice() async {
    final now = DateTime.now();
    if (_currentBackPressTime == null || now.difference(_currentBackPressTime!) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      await Fluttertoast.showToast(msg: 'press back again to exit.');
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<bool> goBackToHome() async {
    // if (selectedIndex == 0 && isLoggedIn ) {
    //   // _drawerItems = DrawerItems.notLoggedIn;
    //   selectedPage = DrawerItems.defaultItems.first.page;
    //   closeDrawer();
    //   return false;
    // }
    // setDrawerItems(isLoggedIn);
    if (api.getUser() == null) {
      return _onGoBackTwice();
    }

    if (selectedIndex == 0) {
      return _onGoBackTwice();
    }
    // selectedPage = DrawerItems.notLoggedIn.first.page;
    setSelectedPage(0);
    return false;
  }

  void setController(AnimationController ac) {
    controller = ac;
  }

  void setIsOpen(bool value) {
    isOpen = value;
    notifyListeners();
  }

  void openDrawer() {
    controller.forward();
    setIsOpen(true);
  }

  void closeDrawer() {
    controller.reverse();
    setIsOpen(false);
  }
}
