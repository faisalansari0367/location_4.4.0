import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class QuestionWithCheckbox extends StatefulWidget {
  final String field, questionNo;
  final ValueChanged<Map>? onChanged;
  final List<String> options;
  final bool multipleSelection;
  const QuestionWithCheckbox({
    super.key,
    required this.field,
    required this.questionNo,
    required this.options,
    this.multipleSelection = false, this.onChanged,
  });

  @override
  State<QuestionWithCheckbox> createState() => _QuestionWithCheckboxState();
}

class _QuestionWithCheckboxState extends State<QuestionWithCheckbox> {
  final formData = {};
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.questionNo}. ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.w,
                ),
              ),
              Expanded(
                child: Text(
                  widget.field,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.w,
                  ),
                ),
              ),
            ],
          ),
          Gap(10.h),
          ...widget.options
              .map(
                (e) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: getValue(widget.field, e),

                    onChanged: (s) {
                      if (!widget.multipleSelection) {
                        setValue(widget.field, e, canSelectOne: true);
                      } else {
                        setValue(widget.field, e);
                      }
                      widget.onChanged?.call(formData);
                      setState(() {});
                    },
                    title: Text(
                      e,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  bool? getValue(String? field, String? id) {
    final data = formData[field!];
    if (data == null) return false;
    if (data is int) return {data}.contains(id);
    return (formData[field] as Set?)?.contains(id);
  }

  void setValue(String field, String id, {bool canSelectOne = false}) {
    final dataSet = <String>{};
    final data = formData[field];
    if (data == null) {
      dataSet.add(id);
      formData[field] = dataSet;
    } else {
      if (!canSelectOne) dataSet.addAll(data);
      dataSet.contains(id) ? dataSet.remove(id) : dataSet.add(id);
      formData[field] = dataSet;
    }
    // print(formData);
  }
}
