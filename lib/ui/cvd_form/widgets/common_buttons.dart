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
            Expanded(
              child: ElevatedButton(
                onPressed: state.currentStep == 0
                    ? null
                    : () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        context.read<CvdCubit>().changeCurrent(state.currentStep - 1);
                      },
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: Size(50.w, 50.h),
                ),
                child: Text('Back'),
              ),
            ),
            Gap(20.w),
            Expanded(
              child: ElevatedButton(
                // onPressed: () async => onContinue,
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: Size(50.w, 50.h),
                ),

                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  onContinue();
                },
                child: Text(
                  'Continue',
                  // style: TextStyle(
                  //   fontSize: 18.w,
                  //   fontWeight: FontWeight.bold,
                  // ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
