import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bottom_sheet/bottom_sheet_service.dart';
import 'focus_nodes/always_disabled_focus_node.dart';
import 'my_text_field.dart';
import 'text_formatters/input_formatters.dart';

class MyDropdownField extends StatefulWidget {
  final String hintText;
  final List<String> options;
  final String? value;
  // final String Function(String)? getLabel;
  final void Function(String?) onChanged;

  const MyDropdownField({
    this.hintText = 'Please select an Option',
    this.options = const [],
    // this.getLabel,
    this.value,
    required this.onChanged,
  });

  @override
  State<MyDropdownField> createState() => _MyDropdownFieldState();
}

class _MyDropdownFieldState extends State<MyDropdownField> {
  late TextEditingController controller;

  @override
  void initState() {
    // if(widget.value)
    controller = TextEditingController(text: widget.value.toString());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      onTap: () => BottomSheetService.showSheet(
        child: Options(
          items: widget.options,
          onChanged: (value) => setState(() {
            controller.text = value;
            // address.state = value;
            widget.onChanged.call(value);
          }),
        ),
      ),
      enabled: true,
      inputFormatters: [CapitalizeAllInputFormatter()],
      hintText: widget.hintText,
      suffixIcon: Icon(Icons.keyboard_arrow_down),
      controller: controller,
      focusNode: AlwaysDisabledFocusNode(),
      readOnly: false,
    );
    // return FormField<T>(
    //   builder: (FormFieldState<T> state) {
    //     return InputDecorator(
    //       decoration: InputDecoration(
    //         // contentPadding: EdgeInsets.symmetric(
    //         //     horizontal: 20.0, vertical: 15.0),
    //         contentPadding: kInputPadding,
    //         labelText: hintText,
    //         // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    //         border: MyDecoration.inputBorder,
    //       ),
    //       isEmpty: value == null || value == '',
    //       child: DropdownButtonHideUnderline(
    //         child: DropdownButton<T>(
    //           value: value,
    //           isDense: true,
    //           onChanged: onChanged,
    //           items: options.map((T value) {
    //             return DropdownMenuItem<T>(
    //               value: value,
    //               child: Text(getLabel == null ? value.toString() : getLabel!(value)),
    //             );
    //           }).toList(),
    //         ),
    //       ),
    //     );
  }
}

class Options extends StatelessWidget {
  final String? hintText;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const Options({
    Key? key,
    required this.onChanged,
    this.items = const [],
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          hintText ?? 'Please select an option',
          style: context.textTheme.headline6?.copyWith(
              // fontWeight: FontWeight.w500,
              // color: Colors.black,
              ),
        ),
        const SizedBox(height: 10),
        ...items
            .map((e) => ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  onTap: () {
                    Get.back();
                    onChanged(e);
                  },
                  title: Text(
                    e,
                    style: context.textTheme.subtitle1?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                  ),
                ))
            .toList()
      ],
    );
  }
}
