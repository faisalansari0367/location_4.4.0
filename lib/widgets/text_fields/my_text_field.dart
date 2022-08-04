import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/my_decoration.dart';

class MyTextField extends StatelessWidget {
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Color? fillColor;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final void Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final int? maxLength;
  final bool isDense;
  final EdgeInsets? contentPadding;
  final TextStyle? hintStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool autoFocus;

  const MyTextField(
      {Key? key,
      this.onChanged,
      this.autoFocus = false,
      this.hintText,
      this.prefixIcon,
      this.controller,
      this.onSubmitted,
      this.fillColor,
      this.validator,
      this.textInputAction,
      this.textInputType,
      this.obscureText = false,
      this.suffixIcon,
      this.focusNode,
      this.maxLength,
      this.contentPadding,
      this.isDense = true,
      this.hintStyle,
      i,
      this.inputFormatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      obscureText: obscureText,
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      keyboardType: textInputType,
      validator: validator,
      textInputAction: textInputAction,
      buildCounter: _buildCounter,
      autofocus: autoFocus,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
        contentPadding: contentPadding ?? const EdgeInsets.fromLTRB(20, 15, 12, 15),
        isDense: isDense,

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        // labelText: hintText,
        // fillColor: fillColor ?? theme.inputDecorationTheme.fillColor,
        hintText: hintText,
        hintStyle: hintStyle ?? TextStyle(color: theme.iconTheme.color),
        // filled: true,
        // focusColor: theme.primaryColor,
        enabledBorder: MyDecoration.inputBorder,
        focusedBorder: MyDecoration.inputBorder,
        border: MyDecoration.inputBorder,

        // contentPadding: EdgeInsets.only(left: .padding),
      ),
    );
  }

  Widget? _buildCounter(BuildContext context,
      {required int currentLength, required bool isFocused, required int? maxLength}) {
    return SizedBox.shrink();
  }
}
