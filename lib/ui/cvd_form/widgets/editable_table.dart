import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditableTable extends StatefulWidget {
  final List? headers;
  final ValueChanged<List<Map>> onRowAdd;
  const EditableTable({Key? key, required this.headers, required this.onRowAdd}) : super(key: key);

  @override
  State<EditableTable> createState() => _EditableTableState();
}

class _EditableTableState extends State<EditableTable> {
  final rows = <Map>{};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Editable(
      columns: widget.headers,
      rows: rows.toList(),
      rowCount: rows.length,
      showCreateButton: true,

      tdStyle: const TextStyle(fontSize: 20),
      columnRatio: 0.4,
      showSaveIcon: true, //set true
      borderColor: Colors.grey.shade300,
      saveIconColor: context.theme.primaryColor.withOpacity(0.8),
      onSubmitted: print,
      onRowSaved: (value) {
        rows.add(value);
        print(rows);
        widget.onRowAdd.call(rows.map((e) => e..remove('row')).toList());
      },
    );
  }
}
