import 'package:background_location/helpers/validator.dart';
import 'package:background_location/widgets/text_fields/focus_nodes/always_disabled_focus_node.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateField extends StatefulWidget {
  final String label;
  final ValueChanged<String>? onChanged;
  final InputDecoration? decoration;
  final String? date;
  final String? Function(String?)? validator;

  const MyDateField({Key? key, this.onChanged, required this.label, this.date, this.decoration, this.validator})
      : super(key: key);

  @override
  State<MyDateField> createState() => _MyDateFieldState();
}

class _MyDateFieldState extends State<MyDateField> {
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
  String formatDate(DateTime date) => DateFormat('dd-MM-yyyy').format(date);
}
