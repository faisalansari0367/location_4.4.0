// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../cubit/cvd_cubit.dart';

class CommonButtons extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback? onBack;

  const CommonButtons({
    Key? key,
    required this.onContinue,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CvdCubit, CvdState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Row(
          children: [
            const Spacer(),
            OutlinedButton(
              onPressed: onContinue,
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18.w,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(10.w),
            OutlinedButton(
              onPressed: () {
                context.read<CvdCubit>().changeCurrent(state.currentStep - 1);
              },
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
              ),
              child: Text(
                'Back',
                style: TextStyle(
                  fontSize: 18.w,
                  // color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
