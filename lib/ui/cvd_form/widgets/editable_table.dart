import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditableTable extends StatefulWidget {
  final List? headers;
  const EditableTable({Key? key, required this.headers}) : super(key: key);

  @override
  State<EditableTable> createState() => _EditableTableState();
}

class _EditableTableState extends State<EditableTable> {
  final rows = [];

  @override
  void initState() {
    // for (var i = 0; i < widget.headers!.length; i++) {
    //   final newMap = {};
    //   newMap['row'] = i;
    //   final item = widget.headers!;

    //   // rows.add(newMap);
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Editable(
      columns: widget.headers,
      rows: rows,
      rowCount: rows.length,
      showCreateButton: true,
      tdStyle: TextStyle(fontSize: 20),
      columnRatio: 0.4,
      showSaveIcon: true, //set true
      borderColor: Colors.grey.shade300,
      saveIconColor: context.theme.primaryColor.withOpacity(0.8),
      onSubmitted: (value) => print(value),
      onRowSaved: (value) {
        rows.add(value);
        print(rows);
      },
    );
  }
}
