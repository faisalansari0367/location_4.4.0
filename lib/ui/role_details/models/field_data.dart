import 'package:api_repo/api_repo.dart';
import 'package:background_location/helpers/validator.dart';
import 'package:background_location/ui/role_details/models/field_types.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FieldData {
  final String name;
  final TextEditingController controller;

  FieldData({
    required this.name,
    required this.controller,
  });

  static FieldType getFieldType(String field) {
    switch (field.camelCase) {
      case UserKeys.email:
        return FieldType.email;
      case UserKeys.phoneNumber:
      case 'mobile':
        return FieldType.phoneNumber;
      case UserKeys.firstName:
        return FieldType.firstName;
      case UserKeys.lastName:
        return FieldType.lastName;
      default:
        return FieldType.text;
    }
  }

  FieldType get fieldType {
    switch (name.camelCase) {
      case 'email':
        return FieldType.email;
      case 'mobile':
      case 'phoneNumber':
        return FieldType.phoneNumber;
      default:
        return FieldType.text;
    }
  }

  String? Function(String?)? getValidator() {
    switch (fieldType) {
      case FieldType.email:
        return Validator.email;
      case FieldType.phoneNumber:
        return Validator.mobileNo;
      default:
        return Validator.text;
    }
  }
}
