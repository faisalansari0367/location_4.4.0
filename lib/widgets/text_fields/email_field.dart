// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bioplus/helpers/validator.dart';
import 'package:bioplus/widgets/text_fields/my_text_field.dart';
import 'package:bioplus/widgets/text_fields/text_formatters/input_formatters.dart';
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? label, initialValue;
  final void Function(String)? onChanged, onSubmitted;
  final InputDecoration? inputDecoration;
  final bool readOnly;
  const EmailField({
    super.key,
    this.controller,
    this.onChanged,
    this.focusNode,
    this.label,
    this.onSubmitted,
    this.inputDecoration,
    this.readOnly = false, this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    // final iconColor = Theme.of(context).iconTheme.color;
    return MyTextField(
      // textCapitalization: TextCapitalization.,
      initialValue: initialValue,
      inputFormatters: [LowerCaseTextFormatter()],
      focusNode: focusNode,
      controller: controller,
      hintText: label ?? 'Email ID',
      readOnly: readOnly,
      decoration: inputDecoration,
      onChanged: onChanged,
      validator: Validator.email,
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email_outlined),
    );
  }
}
