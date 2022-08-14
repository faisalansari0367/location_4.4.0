import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateField extends StatefulWidget {
  final String label;
  final ValueChanged<String>? onChanged;
  final String? date;
  const MyDateField({Key? key, this.onChanged, required this.label, this.date}) : super(key: key);

  @override
  State<MyDateField> createState() => _MyDateFieldState();
}

class _MyDateFieldState extends State<MyDateField> {
  final controller = TextEditingController();

  @override
  void initState() {
    if (widget.date != null) {
      final dt = DateTime.parse(widget.date!);
      controller.text = formatDate(dt);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showDatePicker,
      child: AbsorbPointer(
        child: MyTextField(
          // enabled: false,
          suffixIcon: Icon(Icons.date_range_outlined),
          hintText: widget.label,
          textInputType: TextInputType.datetime,
          controller: controller,
          // validator: (value) => Validator.validateDate(value),
        ),
      ),
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
        controller.text = formatDate(pickedDate);
        widget.onChanged?.call(pickedDate.toIso8601String());
      });
    }
  }

  // create a function to format date
  String formatDate(DateTime date) => DateFormat('dd-MM-yyyy').format(date);
}
