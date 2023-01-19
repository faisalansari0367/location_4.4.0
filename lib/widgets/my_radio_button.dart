import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyRadioButton extends StatelessWidget {
  final String? text;
  final bool? value;
  final bool? selectedValue;
  final ValueChanged<bool?>? onChanged;
  const MyRadioButton({
    super.key,
    this.text,
    this.value,
    this.selectedValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (text == null) return _radio(context);
    return InkWell(
      onTap: () => onChanged?.call(value),
      child: Row(
        children: [
          if (text != null)
            Text(
              text!,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16.h,
                color: Colors.grey.shade600,
              ),
            ),
          _radio(context),
        ],
      ),
    );
  }

  Radio<bool?> _radio(BuildContext context) {
    return Radio<bool?>(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: value,
      groupValue: selectedValue,
      fillColor: MaterialStateProperty.all(context.theme.primaryColor),
      onChanged: onChanged,
    );
  }
}
