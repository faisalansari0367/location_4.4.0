import 'package:bioplus/widgets/text_fields/focus_nodes/always_disabled_focus_node.dart';
import 'package:bioplus/widgets/text_fields/my_text_field.dart';
import 'package:bioplus/widgets/text_fields/text_formatters/input_formatters.dart';
import 'package:flutter/material.dart';

import '../constants/strings.dart';
import '../ui/role_details/widgets/states.dart';
import 'bottom_sheet/bottom_sheet_service.dart';

class StateDropdownField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String? value;
  const StateDropdownField({Key? key, this.onChanged, this.value}) : super(key: key);

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
