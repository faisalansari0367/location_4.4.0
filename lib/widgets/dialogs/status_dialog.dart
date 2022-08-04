// import 'package:flutter/material.dart';
// import 'package:flutter_app/common/common.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';

// import '../../../networks/api_result/NetworkExceptions/NetworkExceptions.dart';

// enum ErrorSuccessWarning { success, error, warning }

// extension ErrorSuccessWarningExt on ErrorSuccessWarning {
//   static final Map<ErrorSuccessWarning, _DialogTypeModel> dialogType = {
//     ErrorSuccessWarning.error: _DialogTypeModel("Error!", ColorConfig.primaryRed),
//     ErrorSuccessWarning.success: _DialogTypeModel("Successful", ColorConfig.lightGreen),
//     ErrorSuccessWarning.warning: _DialogTypeModel("Warning!", ColorConfig.primaryYellow),
//   };
//   _DialogTypeModel get type => dialogType[this]!;
//   bool get isError => this == ErrorSuccessWarning.error;
//   bool get isSuccess => this == ErrorSuccessWarning.success;
//   bool get isWarning => this == ErrorSuccessWarning.warning;
// }

// class _DialogTypeModel {
//   final String message;
//   final Color color;

//   const _DialogTypeModel(this.message, this.color);
// }

// class StatusDialog extends StatefulWidget {
//   final ErrorSuccessWarning dialogType;
//   final String? message;
//   final bool hasCancelButton;
//   final continueTitle;
//   final String title;
//   final VoidCallback? onContinue;
//   const StatusDialog({
//     Key? key,
//     required this.dialogType,
//     this.message,
//     this.hasCancelButton = false,
//     this.continueTitle = 'Continue',
//     this.title = '',
//     this.onContinue,
//   }) : super(key: key);

//   @override
//   State<StatusDialog> createState() => _StatusDialogState();

//   static failure(NetworkExceptions error) {
//     Get.dialog(
//       StatusDialog(
//         dialogType: ErrorSuccessWarning.error,
//         message: NetworkExceptions.getErrorMessage(error),
//       ),
//     );
//   }
// }

// class _StatusDialogState extends State<StatusDialog> {
//   @override
//   Widget build(BuildContext context) {
//     final color = widget.dialogType.type.color;
//     final dialog = widget.dialogType.type;

//     return Dialog(
//       clipBehavior: Clip.antiAlias,
//       shape: RoundedRectangleBorder(
//         borderRadius: kBorderRadius,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             height: 55.h,
//             color: widget.dialogType.type.color.withOpacity(0.2),
//             child: Center(
//               child: Text(
//                 widget.title.isEmpty ? widget.dialogType.name.capitalize! : widget.title,
//                 style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 16.sp),
//               ),
//             ),
//           ),
//           Lottie.asset(
//             "assets/animation/dialog/${widget.dialogType.name}.json",
//             width: 140.w,
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 25.w),
//             child: Text(
//               widget.message ?? dialog.message,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14.w,
//                 color: ColorConfig.primaryGrey.withOpacity(0.6),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           SizedBox(height: 35.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               if (widget.hasCancelButton)
//                 GestureDetector(
//                   onTap: () {
//                     Get.back(result: false);
//                   },
//                   child: Container(
//                     width: 130.w,
//                     height: 45.h,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: ColorConfig.primaryGrey.withOpacity(0.15),
//                             offset: const Offset(2, 2),
//                             spreadRadius: 0,
//                             blurRadius: 8,
//                           )
//                         ],
//                         borderRadius: BorderRadius.circular(5.0)),
//                     child: Center(
//                       child: Text(
//                         "Cancel",
//                         style:
//                             TextStyle(color: ColorConfig.primaryGrey, fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ),
//                 ),
//               GestureDetector(
//                 onTap: widget.onContinue == null
//                     ? () {
//                         Get.close(1);
//                       }
//                     : widget.onContinue,
//                 child: Container(
//                   width: 130.w,
//                   height: 45.h,
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color: ColorConfig.primaryGrey.withOpacity(0.15),
//                         offset: const Offset(2, 2),
//                         spreadRadius: 0,
//                         blurRadius: 8,
//                       ),
//                     ],
//                     color: color.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   child: Center(
//                     child: Text(
//                       widget.continueTitle,
//                       style: TextStyle(
//                         color: widget.dialogType.isWarning ? Colors.white : ColorConfig.primaryGrey,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 33.h)
//         ],
//       ),
//     );
//   }
// }
