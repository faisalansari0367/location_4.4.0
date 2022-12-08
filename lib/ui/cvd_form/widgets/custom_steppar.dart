import 'package:auto_size_text/auto_size_text.dart';
import 'package:bioplus/theme/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../cubit/cvd_cubit.dart';

const todoColor = Colors.grey;
// final _processIndex = 0;

class CustomSteppar extends StatelessWidget {
  final ValueChanged<int> onChanged;
  final List<String> stepper;
  final bool isCompleted;
  final int currentStep;
  const CustomSteppar({
    Key? key,
    required this.stepper,
    this.currentStep = 0,
    required this.onChanged,
    this.isCompleted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _processIndex = currentStep;
    // final _progressValue = ((currentStep + 1) / stepper.length) * 100;
    return Container(
      width: double.infinity,
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.grey.shade100,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      // child: Row(
      //   children: [
      //     Stack(
      //       alignment: Alignment.center,
      //       children: [
      //         SizedBox.square(
      //           dimension: 70,
      //           child: CircularProgressIndicator(
      //             value: _progressValue / 100,
      //             backgroundColor: Colors.grey.shade300,
      //           ),
      //         ),
      //         Text(
      //           '${currentStep + 1} 0f ${stepper.length}',
      //           style: TextStyle(
      //             color: Colors.black,
      //             fontSize: 16.sp,
      //           ),
      //         )
      //       ],
      //     ),
      //     Spacer(),
      //     Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text(
      //           stepper.elementAt(currentStep),
      //           style: context.textTheme.headline6!.copyWith(
      //             color: Colors.black,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         Text(
      //           'Next: ' + stepper.elementAt(currentStep + 1),
      //           style: context.textTheme.bodyMedium?.copyWith(
      //             color: Colors.black45,
      //             fontWeight: FontWeight.w600,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      child: ListView(
        controller: context.read<CvdCubit>().stepController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(bottom: 10.h),
        children: stepper
            .map(
              (v) => step(
                stepper.indexOf(v),
                v,
                isCompleted: context.read<CvdCubit>().isStepCompleted(stepper.indexOf(v)),
              ),
            )
            .toList(),
      ),
    );
  }

  Color getColor(bool isActive, bool isCompleted) {
    if (isActive) {
      return kPrimaryColor.withOpacity(0.9);
    } else if (isCompleted) {
      return Colors.teal.shade300;
    } else {
      return Colors.white;
    }
  }

  // getColors() {

  // }

  Widget step(int index, String name, {bool isCompleted = false}) {
    final isActive = currentStep == index;
    final duration = 200.milliseconds;
    return GestureDetector(
      onTap: () => onChanged.call(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: const BoxDecoration(color: Colors.white),
        height: 100.h,
        child: Column(
          children: [
            AnimatedContainer(
              duration: duration,
              height: 40.r,
              width: 40.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isActive || isCompleted
                    ? Border.all(color: Colors.transparent)
                    : Border.all(color: Colors.grey.shade900),
                // color: isActive || isCompleted ? Colors.teal.shade300 : Color.fromARGB(255, 255, 255, 255),
                color: getColor(isActive, isCompleted),
              ),
              child: AnimatedDefaultTextStyle(
                duration: duration,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.w,
                  color: isActive ? Colors.white : const Color.fromARGB(255, 0, 0, 0),
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    : Text(
                        (index + 1).toString(),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            Gap(8.h),
            AnimatedDefaultTextStyle(
              duration: duration,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.w,
                color: isActive ? kPrimaryColor : const Color.fromARGB(255, 25, 25, 25),
              ),
              child: SizedBox(
                width: 100.w,
                child: AutoSizeText(
                  name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
