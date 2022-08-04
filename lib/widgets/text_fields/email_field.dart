import 'package:background_location/helpers/validator.dart';
import 'package:flutter/material.dart';

import 'my_text_field.dart';

class EmailField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged, onSubmitted;
  const EmailField({
    Key? key,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final iconColor = Theme.of(context).iconTheme.color;
    return MyTextField(
      focusNode: focusNode,
      controller: controller,
      hintText: 'Email ID',
      onChanged: onChanged,
      validator: Validator.email,
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.emailAddress,
      prefixIcon: Icon(Icons.email_outlined),
    );
  }
}
