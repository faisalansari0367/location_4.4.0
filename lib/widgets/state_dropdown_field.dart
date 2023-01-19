import 'package:bioplus/constants/strings.dart';
import 'package:bioplus/ui/role_details/widgets/states.dart';
import 'package:bioplus/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:bioplus/widgets/text_fields/focus_nodes/always_disabled_focus_node.dart';
import 'package:bioplus/widgets/text_fields/my_text_field.dart';
import 'package:bioplus/widgets/text_fields/text_formatters/input_formatters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StateDropdownField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String? value;
  const StateDropdownField({super.key, this.onChanged, this.value});

  @override
  State<StateDropdownField> createState() => _StateDropdownFieldState();
}

class _StateDropdownFieldState extends State<StateDropdownField> {
  late TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StateDropdownField oldWidget) {
    final hasChanged = oldWidget.value != widget.value;
    if (hasChanged) {
      controller = TextEditingController(text: widget.value);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      onTap: () => BottomSheetService.showSheet(
        child: States(
          onChanged: (value) => setState(() {
            controller.text = value;
            widget.onChanged?.call(value);
            Get.back();
          }),
        ),
      ),
      inputFormatters: [CapitalizeAllInputFormatter()],
      hintText: Strings.selectState,
      suffixIcon: const Icon(Icons.keyboard_arrow_down),
      controller: controller,
      focusNode: AlwaysDisabledFocusNode(),
    );
  }
}
