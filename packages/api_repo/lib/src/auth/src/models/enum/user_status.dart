import 'package:flutter/material.dart';

enum UserStatus { active, inactive, delete, unknown }

extension UserStatusExt on UserStatus {
  Color get color {
    switch (this) {
      case UserStatus.active:
        return Colors.teal;
      case UserStatus.inactive:
        return Colors.orange;
      case UserStatus.delete:
        return Colors.red;
      case UserStatus.unknown:
        return Colors.grey;
    }
  }

  String get status {
    return name.replaceFirst(
      name.characters.first,
      name.characters.first.toUpperCase(),
    );
  }
}
