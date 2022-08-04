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

  static BoxDecoration decoration({Color color = Colors.white}) {
    return BoxDecoration(
      color: color,
      borderRadius: kBorderRadius,
    );
  }
}
