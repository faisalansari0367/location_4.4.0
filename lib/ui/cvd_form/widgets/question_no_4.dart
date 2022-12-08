// import 'package:bioplus/constants/index.dart';
// import 'package:bioplus/ui/cvd_form/widgets/question_with_checkbox.dart';
// import 'package:bioplus/widgets/my_appbar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'editable_table.dart';

// class ChemicalUseQuestion4 extends StatefulWidget {
//   const ChemicalUseQuestion4({Key? key}) : super(key: key);

//   @override
//   State<ChemicalUseQuestion4> createState() => _ChemicalUseQuestion4State();
// }

// class _ChemicalUseQuestion4State extends State<ChemicalUseQuestion4> {
//   List<Map> tableData = [];
//   bool showTable = false;
//   final data = {
//     "field":
//         "Is this commodity within a withholding period (WHP), Export Slaughter Interval (ESI) or Export Animal Feed Interval (EAFI) following treatment with any plant chemical including a pickling or seed treatment, fumigant, pesticide or insecticide?",
//     "options": ["Yes, enter details in the table below", "No"],
//     "tableHeader": [
//       {"title": "Chemical applied", "index": 1, "key": "checmical_applied"},
//       {"title": "Rate (Tonne/ Ha)", "index": 1, "key": "Rate (Tonne/ Ha)"},
//       {"title": "Application date", "index": 1, "key": "application_date"},
//       {"title": "WHP/ ESI/ EAFI", "index": 1, "key": "WHP/ ESI/ EAFI"}
//     ]
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         QuestionWithCheckbox(
//           field: data['field'] as String,
//           questionNo: '4',
//           options: data['options'] as List<String>,
//           onChanged: _onChanged,
//         ),
//         if (showTable) _buildTable(),
//       ],
//     );
//   }

//   void _onChanged(Map<dynamic, dynamic> map) {
//     // final value = map
//     final value = map[data['field']];
//     if (value is Set) {
//       if (value.first == 'Yes, enter details in the table below') {
//         showTable = true;
//         setState(() {});
//         Get.to(() => _AddTableDetails());
//       } else {
//         showTable = true;
//         setState(() {});
//       }
//     }
//   }

//   // Container _buildTable() {
//   //   return Container(
//   //     decoration: BoxDecoration(
//   //       border: Border.all(color: Colors.grey.shade300),
//   //       borderRadius: kBorderRadius,
//   //     ),
//   //     height: 30.height,
//   //     child: EditableTable(
//   //       onRowAdd: (value) {
//   //         tableData = value;
//   //       },
//   //       headers: data['tableHeader'] as List,
//   //     ),
//   //   );
//   // }
// }

// class _AddTableDetails extends StatefulWidget {
//   const _AddTableDetails({Key? key}) : super(key: key);

//   @override
//   State<_AddTableDetails> createState() => __AddTableDetailsState();
// }

// class __AddTableDetailsState extends State<_AddTableDetails> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: MyAppBar(),
//       body: Padding(
//         padding: kPadding,
//         child: Column(
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Chemical applied',
//               ),
//             ),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Chemical applied',
//               ),
//             ),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Chemical applied',
//               ),
//             ),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Chemical applied',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
