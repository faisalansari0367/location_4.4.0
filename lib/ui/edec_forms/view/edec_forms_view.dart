import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/cvd_form/view/cvd_from_page.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/my_listTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../widgets/dialogs/coming_soon.dart';
import '../../../widgets/dialogs/dialog_service.dart';

class EdecFormsView extends StatelessWidget {
  const EdecFormsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: const Text('EDEC Forms'),
      ),
      body: Padding(
        padding: kPadding,
        child: AutoSpacing(
          spacing: Gap(15.h),
          children: [
            MyListTile(
              text: 'CVD Form',
              onTap: () async {
                Get.to(() => const CvdFormPage());
              },
            ),
            MyListTile(
                text: 'Feedsafe Personal Qurantine Declaration',
                onTap: () async {
                  comingSoon();
                }),
            MyListTile(
                text: 'Feedsafe Stockfeed Supplier Declaration',
                onTap: () async {
                  comingSoon();
                }),
          ],
        ),
      ),
    );
  }

  void comingSoon() {
    DialogService.showDialog(child: const ComingSoonDialog());
  }
}
