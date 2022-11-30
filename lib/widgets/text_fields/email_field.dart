import 'package:background_location/helpers/validator.dart';
import 'package:flutter/material.dart';

import 'my_text_field.dart';
import 'text_formatters/input_formatters.dart';

class EmailField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final void Function(String)? onChanged, onSubmitted;
  final InputDecoration? inputDecoration;
  const EmailField({
    Key? key,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.focusNode,
    this.inputDecoration,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final iconColor = Theme.of(context).iconTheme.color;
    return MyTextField(
      // textCapitalization: TextCapitalization.,
      inputFormatters: [LowerCaseTextFormatter()],
      focusNode: focusNode,
      controller: controller,
      hintText: label ?? 'Email ID',
      decoration: inputDecoration,
      onChanged: onChanged,
      validator: Validator.email,
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined),
    );
  }
}
