// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:bioplus/ui/role_details/models/field_data.dart';
// import 'package:bioplus/ui/role_details/models/field_types.dart';
// import 'package:bioplus/widgets/my_appbar.dart';
// import 'package:bioplus/widgets/my_radio_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';

// import '../../../constants/index.dart';

// class QrForm extends StatelessWidget {
//   // final Map<String, dynamic> formData;
//   const QrForm({
//     Key? key,
//     // required this.formData,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // print(string);
//     return Scaffold(
//       appBar: MyAppBar(
//         title: Text('Scanned form'),
//         showDivider: true,
//       ),
//       body: ListView.separated(
//         separatorBuilder: (context, index) => Gap(10.h),
//         itemCount: data.length,
//         itemBuilder: itemBuilder,
//         padding: kPadding,
//       ),
//     );
//   }

//   Widget itemBuilder(BuildContext context, int index) {
//     final Map item = data[index];
//     // final children = <Widget>[];
//     // item.forEach((key, value) {
//     //   children.add(
//     //     Row(
//     //       children: [Text(key), Text(value ?? '')],
//     //     ),
//     //   );
//     // });
//     // children.add(FormCard(question: item['question']));
//     // children.add(FormCard(question: item['']));
//     final field = item['question'] as String;
//     // final fieldInCamelCase = field.camelCase;
//     final fieldData = FieldData(name: (field), controller: TextEditingController());

//     if (FieldType.values.contains(fieldData.fieldType)) {
//       if (!fieldData.fieldType.isText) return fieldData.fieldWidget;
//     }
//     return FormCard(question: item['question']);
//   }
// }

