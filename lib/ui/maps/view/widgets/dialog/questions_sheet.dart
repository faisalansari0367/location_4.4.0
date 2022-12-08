import 'package:bioplus/ui/maps/models/polygon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../constants/constans.dart';
import '../../../../../constants/strings.dart';
import '../../../../../widgets/my_elevated_button.dart';

class QuestionsSheet extends StatelessWidget {
  final PolygonModel polygonModel;
  const QuestionsSheet({Key? key, required this.polygonModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      maxChildSize: 0.8,
      // builder
      builder: (context, scrollController) {
        return Container(
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(20.w),
          //     topRight: Radius.circular(20.w),
          //   ),
          // ),
          child: ListView(
            padding: kPadding,
            controller: scrollController,
            children: [
              // Padding(
              //   padding: kPadding,
              //   child: Text(
              //     'Are you visiting below PIC?',
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              Text(
                'Reason for visit',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              const TextField(
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: kBorderRadius),
                  // labelText: 'Reason for visit',
                ),
              ),
              Gap(20.h),
              const MyElevatedButton(
                text: Strings.submit,
              ),
            ],
          ),
        );
      },
    );
  }
}
