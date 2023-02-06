// import 'package:bioplus/constants/index.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class RoundedTextField extends MyTextField {
//   final String? initialValue;
//   final String? hintText;
//   final ValueChanged<>
//   const RoundedTextField();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 5.w),
//           child: Text(
//             hintText ?? '',
//             style: context.theme.textTheme.titleMedium?.copyWith(
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//         Gap(5.h),
//         MyTextField(
//           style: TextStyle(
//             color: Colors.grey.shade700,
//             fontWeight: FontWeight.w600,
//             fontSize: 14.sp,
//             // fontSize: 16.sp,
//           ),
//           // hintText: s,
//           initialValue: initialValue,
//           decoration:
//               MyDecoration.recangularInputDecoration(context).copyWith(),
//         ),
//       ],
//     );
//   }
// }
