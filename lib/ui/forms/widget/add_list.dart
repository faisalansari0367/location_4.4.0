import 'package:bioplus/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddList extends StatefulWidget {
  final ValueChanged<List<String>>? onChanged;
  const AddList({super.key, this.onChanged});

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  // List<String> list = [];
  List<String> fields = [];
  String value = '';
  // final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add visitors',
            style: context.textTheme.bodyMedium,
          ),
          Gap(5.h),
          ...fields
              .map(
                (e) => Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        // focusNode: AlwaysDisabledFocusNode(),
                        enabled: false,
                        controller: TextEditingController(text: e),
                        // decoration: MyDecoration.recangularInputDecoration(context),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        fields.remove(e);
                        setState(() {});
                      },
                      icon: const Icon(Icons.remove),
                    ),
                  ],
                ),
              )
              .toList(),
          _textFiled(),
          Gap(20.h),
        ],
      ),
    );
  }

  Row _textFiled() {
    // controller.addListener((() => setState(() {})));
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Focus(
            onFocusChange: (b) {
              if (!b) {
                fields.add(value);
                value = '';
                widget.onChanged?.call(fields);
                setState(() {});
              }
            },
            child: TextFormField(
              // controller: controller,
              onChanged: (s) {
                setState(() {
                  value = s;
                });
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: value.isEmpty
              ? null
              : () {
                  fields.add(value);
                  widget.onChanged?.call(fields);
                  value = '';
                  setState(() {});
                },
        ),
      ],
    );
  }
}
