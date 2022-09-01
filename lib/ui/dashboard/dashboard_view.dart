import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/view/logbook_page.dart';
import 'package:background_location/ui/dashboard/dashboard_card.dart';
import 'package:background_location/ui/maps/view/maps_page.dart';
import 'package:background_location/ui/settings/view/settings_page.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../gen/assets.gen.dart';
import '../links_page/links_page.dart';
import '../visitor_check_in/visitor_check_in.dart';

class DashboardView extends StatelessWidget {
  final bool fromDrawer;
  const DashboardView({Key? key, this.fromDrawer = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        showBackButton: false,
        title: Text(Strings.dashboard),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              Assets.icons.itrakLogoTransparent.path,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GridView(
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
                onTap: () => Get.to(() => VisitorCheckIn()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
