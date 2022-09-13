import 'package:background_location/constants/index.dart';
import 'package:background_location/widgets/text_fields/focus_nodes/always_disabled_focus_node.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddFields extends StatefulWidget {
  final String field;
  final String? no;
  const AddFields({Key? key, required this.field, this.no}) : super(key: key);

  @override
  State<AddFields> createState() => _AddFieldsState();
}

class _AddFieldsState extends State<AddFields> {
  List<String> fields = [];
  String value = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPadding,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.no != null)
                Text(
                  widget.no!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.w,
                  ),
                ),
              Expanded(
                child: Text(
                  widget.field,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.w,
                  ),
                ),
              ),
            ],
          ),
          Gap(5.h),
          ...fields
              .map(
                (e) => Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        focusNode: AlwaysDisabledFocusNode(),
                        decoration: MyDecoration.recangularInputDecoration(context),
                        onChanged: (s) => value = s,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        fields.remove(e);
                        setState(() {});
                      },
                      icon: Icon(Icons.remove),
                    ),
                  ],
                ),
              )
              .toList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gap(20.w),
              Expanded(
                child: MyTextField(
                  validator: (s) => null,
                  decoration: MyDecoration.recangularInputDecoration(context),
                  onChanged: (s) => setState(() {
                    value = s;
                  }),
                ),
              ),
              IconButton(
                // alignment: Alignment.topCenter,

                padding: EdgeInsets.only(bottom: value.isEmpty ? 20.h : 0.h),
                onPressed: value.isEmpty
                    ? null
                    : () {
                        FocusScope.of(context).unfocus();
                        fields.add(value);
                        value = '';
                        setState(() {});
                      },
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}