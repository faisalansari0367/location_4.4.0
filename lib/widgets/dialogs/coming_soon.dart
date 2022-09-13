import 'package:background_location/widgets/animations/my_scale_transition.dart';
import 'package:background_location/widgets/dialogs/dialog_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../constants/index.dart';
import '../../gen/assets.gen.dart';

class ComingSoonDialog extends StatelessWidget {
  const ComingSoonDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogLayout(
      child: Padding(
        // padding: const EdgeInsets.all(8.0),
        padding: kPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(20.h),
            MyScaleTransition(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  Assets.icons.appIcon.path,
                ),
              ),
            ),
            Gap(30.h),
            Text(
              'Coming soon',
              style: context.textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(20.h),
            ElevatedButton(
              onPressed: Get.back,
              child: Text('Go back'),
              style:
                  OutlinedButton.styleFrom(shape: StadiumBorder(), textStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
