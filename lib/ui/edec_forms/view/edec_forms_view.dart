import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/cvd_form/view/cvd_from_page.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:bioplus/widgets/my_listTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/dialogs/coming_soon.dart';
import '../../../widgets/dialogs/dialog_service.dart';

class EdecFormsView extends StatelessWidget {
  const EdecFormsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: const Text('eDEC Forms'),
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
                text: 'Feedsafe Personal Quarantine Declaration',
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
