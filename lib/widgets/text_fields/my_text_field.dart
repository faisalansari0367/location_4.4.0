import 'package:bioplus/constants/index.dart';
import 'package:bioplus/helpers/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextField extends StatelessWidget {
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final String? hintText, initialValue;
  final Widget? prefixIcon;
  final Color? fillColor;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final void Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final bool obscureText, filled;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final int? maxLength;
  final bool isDense;
  final EdgeInsets? contentPadding;
  final TextStyle? hintStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool autoFocus;
  final bool enabled, readOnly;
  final AutovalidateMode autovalidateMode;
  final int? maxLines, minLine;
  final InputDecoration? decoration;

  final TextCapitalization textCapitalization;

  const MyTextField({
    super.key,
    this.onChanged,
    this.readOnly = false,
    this.initialValue,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.enabled = true,
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
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.sentences,
    this.onTap,
    this.maxLines = 1,
    this.minLine,
    this.filled = false,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      initialValue: initialValue,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      obscureText: obscureText,
      autovalidateMode: autovalidateMode,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLine,
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      keyboardType: textInputType,
      validator: validator ?? Validator.text,
      textInputAction: textInputAction,
      buildCounter: _buildCounter,
      style: const TextStyle(
        // color: theme.iconTheme.color,
        fontWeight: FontWeight.bold,
        // color
      ),
      onTap: onTap,
      autofocus: autoFocus,
      readOnly: readOnly,
      decoration: decoration ??
          InputDecoration(
            labelText: hintText,
            // contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
            contentPadding: contentPadding ?? kInputPadding,
            isDense: isDense,

            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            labelStyle: const TextStyle(
              // color: theme.iconTheme.color,
              fontWeight: FontWeight.bold,
              // color
            ),

            // labelText: hintText,
            fillColor: fillColor,
            // hintText: hintText,
            hintStyle: hintStyle ??
                TextStyle(
                  color: theme.iconTheme.color,
                  // fontWeight: FontWeight.bold,
                ),
            filled: filled,
            // focusColor: theme.primaryColor,
            enabledBorder: MyDecoration.inputBorder,
            focusedBorder: MyDecoration.inputBorder.copyWith(
              borderSide: BorderSide(
                width: 2.w,
                color: theme.primaryColor,
              ),
            ),
            disabledBorder: MyDecoration.inputBorder.copyWith(
              borderSide: BorderSide(
                width: 2.w,
                color: Colors.grey.shade200,
              ),
            ),
            border: MyDecoration.inputBorder,
            // enabled: false,

            // contentPadding: EdgeInsets.only(left: .padding),
          ),
    );
  }

  Widget? _buildCounter(BuildContext context,
      {required int currentLength, required bool isFocused, required int? maxLength,}) {
    return const SizedBox.shrink();
  }
}
