import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/work_safety/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../services/notifications/intent_service.dart';
import '../../../widgets/my_elevated_button.dart';

/// {@template work_safety_body}
/// Body of the WorkSafetyPage.
///
/// Add what it does
/// {@endtemplate}
class WorkSafetyBody extends StatelessWidget {
  /// {@macro work_safety_body}
  const WorkSafetyBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkSafetyCubit, WorkSafetyState>(
      builder: (context, state) {
        return Column(
          children: [
            Image.asset('assets/images/WorSAFETY Image.jpg'),
            Gap(50.h),
            MyElevatedButton(
              width: 70.width,
              child: Text(
                'Register Now',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.sp,
                ),
              ),
              onPressed: () async => IntentService.emailIntent(
                'stewart@itrakassets.com',
                subject: 'Work Safety Program Registration',
                body:
                    '${state.userData.fullName}\n${state.userData.street}\n${state.userData.state}\n${state.userData.postcode}\n${state.userData.phoneNumber}',
              ),
            ),
          ],
        );
      },
    );
  }
}
