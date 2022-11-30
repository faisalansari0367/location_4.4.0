import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'constans.dart';

class MyDecoration {
  static const inputRadius = 50.0;
  static final inputBorderRadius = BorderRadius.circular(inputRadius);
  static const inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(inputRadius)),
    borderSide: BorderSide(color: Color.fromARGB(158, 152, 152, 152)),
  );

  static const dialogShape = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    borderSide: BorderSide(color: Colors.transparent),
  );

  static BoxDecoration decoration({Color color = Colors.white, bool isCircle = false, bool shadow = true}) {
    return BoxDecoration(
      color: color,
      shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      boxShadow: shadow
          ? [
              const BoxShadow(
                color: Color.fromARGB(60, 103, 137, 240),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ]
          : null,
      borderRadius: isCircle ? null : kBorderRadius,
    );
  }

  static InputDecoration recangularInputDecoration(BuildContext context) {
    return InputDecoration(
      filled: true,
      isDense: true,
      fillColor: const Color.fromARGB(0, 250, 250, 250),
      enabledBorder: MyDecoration.inputBorder.copyWith(
        borderRadius: BorderRadius.circular(4.r),
      ),
      focusedBorder: MyDecoration.inputBorder.copyWith(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: BorderSide(
          color: context.theme.primaryColor,
          width: 2.w,
        ),
      ),
      disabledBorder: MyDecoration.inputBorder,
      border: MyDecoration.inputBorder.copyWith(
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }

  static BoxDecoration bottomSheetDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          spreadRadius: 0.1,
        ),
      ],
    );
  }

  static BoxDecoration bottomButtonShadow() {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 255, 255, 255),
          blurRadius: 15,
          offset: Offset(10, 50),
          spreadRadius: 60,
        ),
      ],
    );
  }

  static String formatDate(DateTime? date) => date == null ? '' : DateFormat('dd-MM-yyyy').format(date);
  static String formatTime(DateTime? date) => date == null ? '' : DateFormat('hh:mm:ss a').format(date);
  static String formatDateInYMMMED(DateTime? date) => date == null ? '' : DateFormat.yMMMEd().format(date);
  static String formatDateWithTime(DateTime? dateTime) {
    return '${MyDecoration.formatDate(dateTime)}  ${MyDecoration.formatTime(dateTime)}';
  }
}
