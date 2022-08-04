import 'package:form_validator/form_validator.dart';

class Validator {
  static String? email(String? value) {
    final validate = ValidationBuilder().email('Email is not valid').build();
    final result = validate(value?.trim());
    return result;
  }

  static String? password(String? value) {
    final validate = ValidationBuilder().minLength(3).build();
    final result = validate(value);
    return result;
  }

  static String? name(String? value) {
    final validate = ValidationBuilder().minLength(3).build();
    final result = validate(value);
    return result;
  }

  static String? text(String? value) {
    final validate = ValidationBuilder().minLength(1).build();
    final result = validate(value);
    return result;
  }

  static String? mobileNo(String? value) {
    final validate = ValidationBuilder().phone('Mobile is not valid').build();
    // final validate = ValidationBuilder().minLength(3).build();
    final result = validate(value);
    return result;
  }

  //  static String? dob(String? value) {
  //   final validate = ValidationBuilder().('Mobile is not valid').build();
  //   // final validate = ValidationBuilder().minLength(3).build();
  //   final result = validate(value);
  //   return result;
  // }
}
