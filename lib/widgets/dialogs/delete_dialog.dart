import 'package:bioplus/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import 'dialog_layout.dart';

class DeleteDialog extends StatelessWidget {
  final String? msg;
  final VoidCallback? onConfirm, onCancel;
  const DeleteDialog({Key? key, this.onConfirm, this.onCancel, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(2.height),
          AspectRatio(
            aspectRatio: 16.w / 9.h,
            child: Lottie.asset(
              'assets/animations/delete-icon-animation.json',
              height: 20.height,
            ),
          ),
          Gap(2.height),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              msg ?? Strings.deleteGeofenceMsg,
              textAlign: TextAlign.center,
              style: context.textTheme.headline6?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
              ),
            ),
          ),
          Gap(2.height),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Gap(2.height),
              Expanded(
                child: _button(
                  'Yes',
                  () {
                    onConfirm?.call();
                    Get.back();
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  side: Colors.transparent,
                ),
                // child: ElevatedButton(
                //   child: Text(
                //     'Yes',
                //     style: TextStyle(
                //       fontSize: 16.w,
                //       fontWeight: FontWeight.w600,
                //       // color: Colors.black,
                //     ),
                //   ),
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.red,
                //     shape: StadiumBorder(),
                //     minimumSize: Size(100.w, 50.h),
                //   ),
              ),
              Gap(2.height),
              Expanded(
                child: _button(
                  'No',
                  () {
                    onCancel?.call();
                    Get.back();
                  },
                ),
                // child: ElevatedButton(
                //   child: Text(
                //     'No',
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontSize: 16.w,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                //   onPressed: Get.back,
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.white,
                //     shape: StadiumBorder(),
                //     side: BorderSide(color: Colors.black38),
                //     minimumSize: Size(100.w, 50.h),
                //   ),
                // ),
              ),
              Gap(2.height),
            ],
          ),
          Gap(2.height),
        ],
      ),
    );
  }

  Widget _button(
    String title,
    VoidCallback onPressed, {
    Color color = Colors.white,
    Color textColor = Colors.black,
    Color side = Colors.black38,
  }) {
    return ElevatedButton(
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 16.w,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: StadiumBorder(),
        side: BorderSide(color: side),
        minimumSize: Size(100.w, 50.h),
      ),
    );
  }
}
