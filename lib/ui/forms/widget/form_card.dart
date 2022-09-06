import 'package:background_location/widgets/my_radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../constants/index.dart';

class QuestionCard extends StatelessWidget {
  final String question;
  final String? selectedValue;
  final ValueChanged<String>? onChanged;

  const QuestionCard({
    Key? key,
    required this.question,
    this.selectedValue,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kPadding.copyWith(bottom: 0),
      decoration: BoxDecoration(
        borderRadius: kBorderRadius,
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            question.trim(),
            style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w600,
              fontSize: 16.h,
            ),
          ),
          Gap(10.h),
          Row(
            children: [
              MyRadioButton(
                text: 'Yes',
                value: true,
                selectedValue: groupValue,
                onChanged: _onChanged,
              ),
              Gap(30.w),
              MyRadioButton(
                text: 'No',
                value: false,
                selectedValue: groupValue,
                onChanged: _onChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool? get groupValue => selectedValue == null ? null : selectedValue == 'yes';
  bool? value(String value) => selectedValue == null ? null : selectedValue == value;

  void _onChanged(bool? value) {
    if (value == null) return;
    final data = value ? 'yes' : 'no';
    onChanged?.call(data);
  }
}
