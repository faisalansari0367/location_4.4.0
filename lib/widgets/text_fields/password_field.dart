import 'package:flutter/material.dart';

import '../../helpers/validator.dart';
import 'my_text_field.dart';

class PasswordField extends StatefulWidget {
  final void Function(String)? onChanged, onSubmitted;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? hintText;
  final TextInputAction textInputAction;
  const PasswordField({
    Key? key,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.validator,
    this.hintText,
    this.textInputAction = TextInputAction.done,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  void updateObscureText() {
    obscureText = !obscureText;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color;
    return MyTextField(
      controller: widget.controller,
      validator: widget.validator ?? Validator.password,
      onChanged: widget.onChanged,
      obscureText: obscureText,
      suffixIcon: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: iconColor,
        ),
        onPressed: updateObscureText,
      ),
      hintText: widget.hintText ?? 'Password',
      onSubmitted: widget.onSubmitted,
      textInputAction: widget.textInputAction,
      textInputType: TextInputType.visiblePassword,
      prefixIcon: Icon(
        Icons.lock_outlined,
      ),
    );
  }
}
