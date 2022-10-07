// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';

// class DropdownOptions<T> extends StatelessWidget {
//   final List<T> options;
//   final String? title;
//   final T? value;
//   final ValueChanged<T> onChanged;
//   final bool showTitle;
//   final String Function(T)? labelBuilder;
//   const DropdownOptions({
//     Key? key,
//     required this.options,
//     required this.onChanged,
//     this.labelBuilder,
//     this.title,
//     this.value,
//     this.showTitle = true,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (showTitle)
//           Text(
//             'Please select an option',
//             style: context.textTheme.headline6,
//           ),
//         if (showTitle) Gap(10.h),
//         for (var i in options)
//           ListTile(
//             onTap: () {
//               onChanged.call(i);
//             },
//             selected: i == value,
//             selectedColor: Colors.red,
//             // selectedTileColor: Colors  .green,

//             // selectedTileColor: context.theme.primaryColor.withOpacity(0.2),
//             // selectedColor: context.theme.primaryColor.withOpacity(0.9),
//             contentPadding: EdgeInsets.zero,
//             title: Text(
//               labelBuilder != null ? labelBuilder!(i) : i.toString(),
//             ),
//           ),
//       ],
//     );
//   }
// }
