import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/view/logbook_page.dart';
import 'package:background_location/ui/cvd_form/view/cvd_from_page.dart';
import 'package:background_location/ui/dashboard/dashboard_card.dart';
import 'package:background_location/ui/forms/view/forms_page.dart';
import 'package:background_location/ui/maps/view/maps_page.dart';
import 'package:background_location/ui/select_role/view/select_role_page.dart';
import 'package:background_location/ui/visitor_check_in/view/visitor_check_in_page.dart';
import 'package:background_location/widgets/dialogs/coming_soon.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../links_page/links_page.dart';

class DashboardView extends StatelessWidget {
  final bool fromDrawer;
  const DashboardView({Key? key, this.fromDrawer = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        showBackButton: false,
        centreTitle: true,
        // title: _logo(),
      ),
      body: SingleChildScrollView(
        child: Column(
          // alignment: Alignment.center,
          children: [
            _logo(),
            // Positioned(
            //   child: Image.asset(
            //     'assets/icons/BIO_shield1 (1).png',
            //     height: 26.height,
            //   ),
            // ),
            GridView(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              padding: kPadding,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: kPadding.left.h,
                crossAxisSpacing: kPadding.left.w,
              ),
              children: [
                DashboardCard(
                  text: Strings.visitorLogBook.toUpperCase(),
                  iconData: Icons.book,
                  onTap: () => Get.to(() => LogbookPage()),
                ),
                DashboardCard(
                  text: Strings.geofences.toUpperCase(),
                  iconData: Icons.fence,
                  onTap: () => Get.to(() => MapsPage()),
                ),
                DashboardCard(
                  text: Strings.settings.toUpperCase(),
                  iconData: Icons.settings,
                  onTap: () => Get.to(
                    // () => SettingsPage(
                    //   showBackbutton: true,
                    // ),
                    SelectRolePage(
                      showBackArrow: true,
                    ),
                  ),
                ),
                DashboardCard(
                  text: Strings.envds,
                  iconData: Icons.person,
                  onTap: () => DialogService.showDialog(child: ComingSoonDialog()),
                ),
                DashboardCard(
                  text: Strings.links.toUpperCase(),
                  iconData: Icons.link,
                  onTap: () => Get.to(() => LinksPage()),
                ),
                DashboardCard(
                  text: Strings.visitorCheckIn.toUpperCase(),
                  iconData: Icons.token_rounded,
                  onTap: () => Get.to(() => VisitorCheckInPage()),
                ),
                DashboardCard(
                  text: 'eDEC Forms',
                  iconData: Icons.format_list_bulleted_sharp,
                  onTap: () {
                    DialogService.showDialog(child: ComingSoonDialog());
                  },
                  // onTap: () => Get.to(() => VisitorCheckInPage()),
                ),
                DashboardCard(
                  text: 'CVD FORM',
                  iconData: Icons.format_align_justify_rounded,
                  onTap: () => Get.to(() => CvdFormPage()),
                ),
                DashboardCard(
                  text: 'WORK SAFETY',
                  iconData: Icons.work_outline,
                  onTap: () {
                    DialogService.showDialog(child: ComingSoonDialog());
                  },
                ),
                // DashboardCard(
                //   text: 'FORMS',
                //   iconData: Icons.work_outline,
                //   onTap: () {
                //     Get.to(() => FormsPage());
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _logo() {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        // Gap(20.h),
        Image.asset(
          'assets/icons/BIO_shield1 (1).png',
          height: 7.height,
        ),
        Text(
          'BIO',
          style: TextStyle(
            color: Color(0xff3B4798),
            fontWeight: FontWeight.bold,
            fontSize: 20.w,
          ),
        ),
        Text(
          'SECURE',
          style: TextStyle(
            color: Color(0xff75B950),
            fontWeight: FontWeight.bold,
            fontSize: 20.w,
          ),
        ),
      ],
    );
  }
}
