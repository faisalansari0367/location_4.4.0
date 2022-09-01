import 'package:background_location/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetService {
  static void showSheet({required Widget child}) {
    Get.bottomSheet(
      Container(
        decoration: MyDecoration.bottomSheetDecoration(),
        child: child,
        padding: kPadding,
      ),
      enterBottomSheetDuration: 175.milliseconds,
      exitBottomSheetDuration: 175.milliseconds,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.1),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
