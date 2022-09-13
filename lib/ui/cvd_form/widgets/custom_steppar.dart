import 'package:background_location/theme/color_constants.dart';
import 'package:background_location/ui/cvd_form/cubit/cvd_cubit.dart';
import 'package:background_location/ui/cvd_form/widgets/form_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

final todoColor = Colors.grey;
// final _processIndex = 0;

class CustomSteppar extends StatelessWidget {
  final ValueChanged<int> onChanged;
  final List<FormStepper> stepper;
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
    print(isCompleted);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            // spreadRadius: 10,
            blurRadius: 10,
            color: Colors.grey.shade100,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(bottom: 10),
        child: Container(
          // decoration: BoxDecoration(
          //   boxShadow: [
          //     BoxShadow(
          //       // spreadRadius: 10,
          //       blurRadius: 10,
          //       color: Colors.grey.shade300,
          //       offset: Offset(0, 10),
          //     ),
          //   ],
          // ),
          child: Row(
            children: stepper
                .map(
                  (v) => step(
                    stepper.indexOf(v),
                    v.heading,
                    isCompleted: context.read<CvdCubit>().isStepCompleted(stepper.indexOf(v)),
                  ),
                )
                .toList(),
          ),
        ),
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
    // if (index == _processIndex) {
    //   return inProgressColor;
    // } else if (index < _processIndex) {
    //   return Colors.green;
    // } else {
    //   return todoColor;
    // }
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
        decoration: BoxDecoration(color: Colors.white),
        height: 100.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
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
                  color: isActive ? Colors.white : Color.fromARGB(255, 0, 0, 0),
                ),
                child: isCompleted
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    : Text(
                        (index + 1).toString(),
                        textAlign: TextAlign.center,
                        // style: TextStyle(color: Colors.black),
                      ),
              ),
            ),
            Gap(8.h),
            // if (currentStep == index)
            AnimatedDefaultTextStyle(
              duration: duration,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.w,
                color: isActive ? kPrimaryColor : Color.fromARGB(255, 25, 25, 25),
              ),
              child: SizedBox(
                // constraints: BoxConstraints(
                // maxWidth: 100.w,
                // minWidth: 50.w,
                // ),
                width: 80.w,
                child: Text(
                  // name.replaceAll(' ', '\n'),
                  name,
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
