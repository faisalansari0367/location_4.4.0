import 'package:bioplus/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:bioplus/widgets/text_fields/focus_nodes/always_disabled_focus_node.dart';
import 'package:bioplus/widgets/text_fields/my_text_field.dart';
import 'package:bioplus/widgets/text_fields/text_formatters/input_formatters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  void didUpdateWidget(covariant MyDropdownField oldWidget) {
    if (oldWidget.value != widget.value) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        controller.text = widget.value.toString();
      });
    }
    super.didUpdateWidget(oldWidget);
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
        child: DraggableScrollableSheet(
          maxChildSize: 0.9,
          expand: false,
          minChildSize: 0.2,
          builder: (context, scrollController) {
            return Options(
              controller: scrollController,
              items: widget.options,
              onChanged: (value) => setState(
                () {
                  FocusScope.of(context).nextFocus();
                  controller.text = value;
                  // address.state = value;
                  widget.onChanged.call(value);
                },
              ),
            );
          },
        ),
        // child: Options(
        //   items: widget.options,
        //   onChanged: (value) => setState(() {
        //     controller.text = value;
        //     // address.state = value;
        //     widget.onChanged.call(value);
        //   }),
        // ),
      ),
      inputFormatters: [CapitalizeAllInputFormatter()],
      hintText: widget.hintText,
      suffixIcon: const Icon(Icons.keyboard_arrow_down),
      controller: controller,
      focusNode: AlwaysDisabledFocusNode(),
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
  final ScrollController controller;

  const Options({
    super.key,
    required this.onChanged,
    this.items = const [],
    this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          hintText ?? 'Please select an option',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            // color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: items
                  .map(
                    (e) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(),
                      onTap: () {
                        Get.back();
                        onChanged(e);
                      },
                      title: Text(
                        e.trim(),
                        style: context.textTheme.titleMedium?.copyWith(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
