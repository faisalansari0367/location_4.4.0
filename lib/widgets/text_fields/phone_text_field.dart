import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/strings.dart';
import '../../helpers/validator.dart';
import 'my_text_field.dart';

class PhoneTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const PhoneTextField({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      maxLength: 10,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      onChanged: onChanged,
      prefixIcon: Icon(Icons.phone),
      hintText: Strings.mobile,
      validator: Validator.mobileNo,
    );
  }
}
