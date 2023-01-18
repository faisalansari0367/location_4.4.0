import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/sos_warning/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// {@template sos_warning_body}
/// Body of the SosWarningPage.
///
/// Add what it does
/// {@endtemplate}
class SosWarningBody extends StatelessWidget {
  /// {@macro sos_warning_body}
  const SosWarningBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SosWarningCubit, SosWarningState>(
      builder: (context, state) {
        return Padding(
          padding: kPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons/SOS icon.png',
              ),
              Gap(75.h),
              Text(
                'Emergency SOS',
                textAlign: TextAlign.center,
                style: context.textTheme.headline5?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Gap(20.h),
              Text(
                'Are you sure you want to send an SOS?',
                textAlign: TextAlign.center,
                style: context.textTheme.headline6?.copyWith(),
              ),
              Gap(20.h),
              Text(
                'This will send your location to your emergency contacts.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyText1?.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              Gap(20.h),
              Row(
                children: [
                  Expanded(
                    child: MyElevatedButton(
                      text: 'Cancel',
                      color: Colors.black,
                      onPressed: () async {
                        Get.back();
                      },
                    ),
                  ),
                  // Gap(20.width),
                  // Spacer(),
                  Gap(20.w),
                  Expanded(
                    child: MyElevatedButton(
                      text: 'Yes',
                      color: Colors.red,
                      onPressed: () async {
                        Get.back();
                        await context.read<SosWarningCubit>().sendSos();
                      },
                    ),
                  ),
                  // Gap(10.width),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
