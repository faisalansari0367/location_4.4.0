import 'package:flutter/services.dart';

class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    return newValue.copyWith(
      text: newValue.text.replaceFirst(
        newValue.text[0],
        newValue.text[0].toUpperCase(),
      ),
    );
  }
}

class CapitalizeAllInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class DefaultInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text);
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toLowerCase());
  }
}

// FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))

// class NumbersInputFormatter extends TextInputFormatter {
//   @override
//   @override
//   TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
//     // TODO: implement formatEditUpdate
//     // return FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
//     // throw UnimplementedError();
//   }
// }
