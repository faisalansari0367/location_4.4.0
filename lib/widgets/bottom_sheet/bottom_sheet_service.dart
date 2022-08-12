import 'package:background_location/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetService {
  static void showSheet({required Widget child}) {
    Get.bottomSheet(
      Padding(
        child: child,
        padding: kPadding,
      ),
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.1),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      // curve: Curves.easeInOut,
    );
  }
}
