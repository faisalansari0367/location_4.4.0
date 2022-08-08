import 'package:flutter/material.dart';

import 'constans.dart';

class MyDecoration {
  static const inputRadius = 50.0;
  static final inputBorderRadius = BorderRadius.circular(inputRadius);
  static const inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(50)),
    borderSide: BorderSide(color: Color.fromARGB(158, 152, 152, 152)),
  );

  static const dialogShape = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    borderSide: BorderSide(color: Colors.transparent),
  );

  static BoxDecoration decoration({Color color = Colors.white, bool isCircle = false}) {
    return BoxDecoration(
      color: color,
      shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(158, 152, 152, 152),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
      borderRadius: isCircle ? null : kBorderRadius,
    );
  }
}
