import 'package:bioplus/constants/index.dart';
import 'package:bioplus/widgets/text_fields/focus_nodes/always_disabled_focus_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddFields extends StatefulWidget {
  final String field;
  final ValueChanged<List<String>> onChanged;
  final String? value;
  final String? no;

  const AddFields({Key? key, required this.field, this.value, required this.onChanged, this.no}) : super(key: key);

  @override
  State<AddFields> createState() => _AddFieldsState();
}

class _AddFieldsState extends State<AddFields> {
  List<String> fields = [];
  String value = '';

  @override
  void initState() {
    if (widget.value != null || (widget.value?.isNotEmpty ?? false)) {
      fields = widget.value!.split(',').toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MyDecoration.decoration().copyWith(border: Border.all(color: Colors.grey.shade200)),
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
                      child: TextFormField(
                        focusNode: AlwaysDisabledFocusNode(),
                        initialValue: e,
                        // decoration: MyDecoration.recangularInputDecoration(context),
                        onChanged: (s) => value = s,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        fields.remove(e);
                        widget.onChanged.call(fields);
                        setState(() {});
                      },
                      icon: const Icon(Icons.remove),
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
                child: Focus(
                  onFocusChange: (b) {
                    if (!b) {
                      fields.add(value);
                      value = '';
                      widget.onChanged.call(fields);
                      setState(() {});
                    }
                  },
                  child: TextFormField(
                    validator: (s) => null,
                    // decoration: MyDecoration.recangularInputDecoration(context),
                    onChanged: (s) => setState(() {
                      value = s;
                    }),
                  ),
                ),
              ),
              IconButton(
                // alignment: Alignment.topCenter,

                // padding: EdgeInsets.only(bottom: value.isEmpty ? 20.h : 0.h),
                onPressed: value.isEmpty
                    ? null
                    : () {
                        // FocusScope.of(context).unfocus();
                        fields.add(value);
                        value = '';
                        widget.onChanged.call(fields);
                        setState(() {});
                      },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
