import 'package:flutter/material.dart';

enum FieldAssets {
  cow,
  paddyFields,
  sheep,
  tractor,
}

extension FieldAssetsExt on FieldAssets {
  bool get isCow => this == FieldAssets.cow;
  bool get isTractor => this == FieldAssets.tractor;
  bool get isSheep => this == FieldAssets.sheep;
  bool get isPaddyFields => this == FieldAssets.paddyFields;

  Color get color {
    switch (this) {
      case FieldAssets.cow:
        return Colors.red;
      case FieldAssets.tractor:
        return Colors.blue;
      case FieldAssets.sheep:
        return Colors.pink;
      case FieldAssets.paddyFields:
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
