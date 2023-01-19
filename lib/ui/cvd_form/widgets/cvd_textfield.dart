import 'package:bioplus/widgets/text_fields/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CvdTextField extends StatefulWidget {
  final String? name;
  final String? value;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final int? maxLength;

  // final TextEditingController controller;
  const CvdTextField({
    super.key,
    this.name,
    this.value,
    this.onChanged,
    this.textInputAction,
    this.textInputType,
    this.validator,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.sentences,
    this.maxLength,
  });

  @override
  State<CvdTextField> createState() => _CvdTextFieldState();
}

class _CvdTextFieldState extends State<CvdTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   widget.name,
        //   style: TextStyle(
        //     fontWeight: FontWeight.w600,
        //     fontSize: 18.w,
        //   ),
        // ),
        // Gap(5.h),
        MyTextField(
          textCapitalization: widget.textCapitalization,
          hintText: widget.name,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          textInputType: widget.textInputType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          controller: controller,
          // decoration: MyDecoration.recangularInputDecoration(context),
        ),
      ],
    );
  }
}
