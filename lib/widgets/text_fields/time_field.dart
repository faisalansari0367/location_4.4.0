import 'package:bioplus/helpers/validator.dart';
import 'package:bioplus/widgets/text_fields/focus_nodes/always_disabled_focus_node.dart';
import 'package:bioplus/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyTimeField extends StatefulWidget {
  final String label;
  final ValueChanged<String>? onChanged;
  final String? date;

  const MyTimeField({
    Key? key,
    this.onChanged,
    required this.label,
    this.date,
  }) : super(key: key);

  @override
  State<MyTimeField> createState() => _MyTimeFieldState();
}

class _MyTimeFieldState extends State<MyTimeField> {
  final controller = TextEditingController();
  DateTime? pickedDateTime;

  @override
  void initState() {
    if (![null, ''].contains(widget.date)) {
      final dt = DateTime.parse(widget.date!);
      pickedDateTime = dt;
      controller.text = formatDate(dt);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      focusNode: AlwaysDisabledFocusNode(),
      onTap: _timePicker,
      suffixIcon: const Icon(Icons.timer_outlined),
      hintText: widget.label,
      textInputType: TextInputType.datetime,
      controller: controller,
      validator: (s) => Validator.date(pickedDateTime),
    );
  }

  void _timePicker() async {
    final pickedDate = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedDate != null) {
      final currentDate = DateTime.now();
      pickedDateTime = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        pickedDate.hour,
        pickedDate.minute,
      );
      controller.text = formatDate(pickedDateTime!);
      widget.onChanged!(pickedDateTime.toString());
    }
  }

  // create a function to format date
  String formatDate(DateTime date) => DateFormat('hh:mm a').format(date.toLocal());
}
