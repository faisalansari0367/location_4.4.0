import 'package:background_location/constants/index.dart';
import 'package:flutter/material.dart';

class BottomSheetService {
  static void showSheet({required Widget child, EdgeInsets? padding}) {
    Get.bottomSheet(
      Container(
        decoration: MyDecoration.bottomSheetDecoration(),
        padding: padding?? kPadding,
        child: child,
      ),
      enterBottomSheetDuration: 175.milliseconds,
      exitBottomSheetDuration: 175.milliseconds,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.1),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
