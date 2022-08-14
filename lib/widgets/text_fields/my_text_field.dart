import 'package:background_location/constants/index.dart';
import 'package:background_location/helpers/validator.dart';
import 'package:background_location/widgets/text_fields/text_formatters/CapitalizeFirstLetter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
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
  final bool enabled, readOnly;
  final AutovalidateMode autovalidateMode;

  final TextCapitalization textCapitalization;

  const MyTextField({
    Key? key,
    this.onChanged,
    this.readOnly = false,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters ?? [CapitalizeFirstLetterFormatter()],
      focusNode: focusNode,
      obscureText: obscureText,
      autovalidateMode: autovalidateMode,
      enabled: enabled,
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      keyboardType: textInputType,
      validator: validator ?? Validator.text,
      textInputAction: textInputAction,
      buildCounter: _buildCounter,
      onTap: onTap,
      autofocus: autoFocus,
      enableSuggestions: true,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: hintText,
        // contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
        contentPadding: contentPadding ?? kInputPadding,
        isDense: isDense,

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        // labelText: hintText,
        // fillColor: fillColor ?? theme.inputDecorationTheme.fillColor,
        // hintText: hintText,
        hintStyle: hintStyle ?? TextStyle(color: theme.iconTheme.color),
        // filled: true,
        // focusColor: theme.primaryColor,
        enabledBorder: MyDecoration.inputBorder,
        focusedBorder: MyDecoration.inputBorder.copyWith(
          borderSide: BorderSide(color: theme.primaryColor),
        ),
        disabledBorder: MyDecoration.inputBorder,
        border: MyDecoration.inputBorder,
        // enabled: false,

        // contentPadding: EdgeInsets.only(left: .padding),
      ),
    );
  }

  Widget? _buildCounter(BuildContext context,
      {required int currentLength, required bool isFocused, required int? maxLength}) {
    return SizedBox.shrink();
  }
}
