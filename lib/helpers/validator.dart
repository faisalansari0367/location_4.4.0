import 'package:email_validator/email_validator.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';

class Validator {
  static String? email(String? value) {
    final isValidated = EmailValidator.validate(value?.trim() ?? '');
    final result = isValidated ? null : 'Email is not valid';
    return result;
  }

  static String? password(String? value) {
    final validate = ValidationBuilder().minLength(6).build();
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

  static String? pic(String? value) {
    if (value == null || value.isEmpty) return null;
    final validate = ValidationBuilder().minLength(8).build();
    final result = validate(value);
    return result;
  }

  static String? postcode(String? value) {
    final validate = ValidationBuilder().minLength(4).build();
    if (value?.isNotEmpty ?? false) {
      final parseCode = int.tryParse(value!);
      if (parseCode == null) return 'Postcode must be in the format 1234';
    }
    final result = validate(value);
    return result;
  }

  static String? mobileNo(String? value) {
    final validate = ValidationBuilder().phone('Mobile is not valid').build();
    final result = validate(value);
    return result;
  }

  static String? date(DateTime? date) {
    if (date == null) return 'This field is required';
    String? message;
    if (date.isBefore(DateTime.now().subtract(10.days))) {
      message = "Can't be more than 10 days before today's date";
    }
    return message;
  }

  static String? none(String? value) => null;

  //  static String? dob(String? value) {
  //   final validate = ValidationBuilder().('Mobile is not valid').build();
  //   // final validate = ValidationBuilder().minLength(3).build();
  //   final result = validate(value);
  //   return result;
  // }
}
