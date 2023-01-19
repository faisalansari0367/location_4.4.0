// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:bioplus/constants/index.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:share_plus/share_plus.dart';

// class CvdPopupMenu extends StatelessWidget {

//   const CvdPopupMenu({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton(
//       onSelected: (value) {
//         switch (value) {
//           case 1:
//             Share.shareFiles([file.path]);
//             break;
//           case 2:
//             state.deleteForm(cvdForm);
//             break;
//           case 3:
//             state.uploadForm(cvdForm);
//             break;
//         }
//       },
//       shape: const RoundedRectangleBorder(
//         borderRadius: kBorderRadius,
//       ),
//       itemBuilder: (context) => [
//         _item(),
//         PopupMenuItem(
//           value: 2,
//           child: Row(
//             children: [
//               const Icon(Icons.delete),
//               Gap(10.w),
//               const Text('Delete'),
//             ],
//           ),
//         ),
//         PopupMenuItem(
//           value: 3,
//           child: Row(
//             children: [
//               const Icon(Icons.upload_file),
//               Gap(10.w),
//               const Text('Upload'),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   PopupMenuItem<int> _item() {
//     return PopupMenuItem(
//       value: 1,
//       child: Row(
//         children: [
//           const Icon(Icons.share),
//           Gap(10.w),
//           const Text('Share'),
//         ],
//       ),
//     );
//   }
// }

// class CvdPopupModel {
//   final int value;
//   final String title;
//   final IconData icon;
//   CvdPopupModel({
//     required this.title,
//     required this.icon,
//     required this.value,
//   });
// }
