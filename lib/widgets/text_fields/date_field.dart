import 'package:bioplus/constants/index.dart';
import 'package:bioplus/helpers/validator.dart';
import 'package:bioplus/widgets/text_fields/focus_nodes/always_disabled_focus_node.dart';
import 'package:flutter/material.dart';

class MyDateField extends StatefulWidget {
  final String label;
  final ValueChanged<String>? onChanged;
  final InputDecoration? decoration;
  final bool showTime;
  final String? date;
  final String? Function(String?)? validator;

  const MyDateField({
    super.key,
    this.onChanged,
    required this.label,
    this.date,
    this.decoration,
    this.validator,
    this.showTime = false,
  });

  @override
  State<MyDateField> createState() => _MyDateFieldState();
}

class _MyDateFieldState extends State<MyDateField> {
  final controller = TextEditingController();
  DateTime? pickedDateTime;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    if (![null, ''].contains(widget.date)) {
      final dt = DateTime.parse(widget.date!);
      pickedDateTime = dt;
      controller.text = formatDate(dt);
    }
  }

  @override
  void didUpdateWidget(covariant MyDateField oldWidget) {
    _init();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      focusNode: AlwaysDisabledFocusNode(),
      onTap: _showDatePicker,
      decoration: widget.decoration,
      suffixIcon: const Icon(Icons.date_range_outlined),
      hintText: widget.label,
      textInputType: TextInputType.datetime,
      controller: controller,
      validator: widget.validator ?? (s) => Validator.date(pickedDateTime),
    );
  }

  _showDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        pickedDateTime = pickedDate;
        controller.text = formatDate(pickedDate);
        widget.onChanged?.call(pickedDate.toIso8601String());
      });
    }
  }

  // create a function to format date
  String formatDate(DateTime date) => widget.showTime
      ? '${MyDecoration.formatDate(date)}  :  ${MyDecoration.formatTime(date)}'
      : MyDecoration.formatDate(date);
}
