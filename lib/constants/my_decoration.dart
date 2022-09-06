import 'package:flutter/material.dart';

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
              BoxShadow(
                color: Color.fromARGB(60, 103, 137, 240),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ]
          : null,
      borderRadius: isCircle ? null : kBorderRadius,
    );
  }

  static BoxDecoration bottomSheetDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          spreadRadius: 0.1,
        ),
      ],
    );
  }
}
