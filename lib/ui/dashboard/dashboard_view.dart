import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/view/logbook_page.dart';
import 'package:background_location/ui/cvd_form/view/cvd_from_page.dart';
import 'package:background_location/ui/dashboard/dashboard_card.dart';
import 'package:background_location/ui/maps/view/maps_page.dart';
import 'package:background_location/ui/settings/view/settings_page.dart';
import 'package:background_location/ui/visitor_check_in/view/visitor_check_in_page.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';

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
        title: Image.asset(
          'assets/icons/dashboard/dashboard_logo.png',
          height: 6.height,
        ),
      ),
      body: Column(
        children: [
          // Row(
          //   children: [
          //     // Gap(20.w),
          //     Image.asset(
          //       'assets/icons/dashboard/dashboard_logo.png',
          //       height: 6.height,
          //     ),
          //     // Spacer(),
          //   ],
          // ),
          Expanded(
            child: GridView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: kPadding,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: kPadding.left,
                crossAxisSpacing: kPadding.left,
              ),
              children: [
                DashboardCard(
                  text: Strings.visitorLogBook,
                  iconData: Icons.book,
                  onTap: () => Get.to(() => LogbookPage()),
                ),
                DashboardCard(
                  text: Strings.geofences,
                  iconData: Icons.fence,
                  onTap: () => Get.to(() => MapsPage()),
                ),
                DashboardCard(
                  text: Strings.settings,
                  iconData: Icons.settings,
                  onTap: () => Get.to(() => SettingsPage(
                        showBackbutton: true,
                      )),
                ),
                DashboardCard(
                  text: Strings.envds,
                  iconData: Icons.person,
                ),
                DashboardCard(
                  text: Strings.links,
                  iconData: Icons.link,
                  onTap: () => Get.to(() => LinksPage()),
                ),
                DashboardCard(
                  text: Strings.visitorCheckIn,
                  iconData: Icons.token_rounded,
                  onTap: () => Get.to(() => VisitorCheckInPage()),
                ),
                DashboardCard(
                  text: 'eDec Forms',
                  iconData: Icons.format_list_bulleted_sharp,
                  // onTap: () => Get.to(() => VisitorCheckInPage()),
                ),
                DashboardCard(
                  text: 'CVD',
                  iconData: LineIcon.conciergeBell().icon,
                  onTap: () => Get.to(() => CvdFormPage()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
