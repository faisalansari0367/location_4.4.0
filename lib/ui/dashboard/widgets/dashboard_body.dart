import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/dashboard/dashboard.dart';
import 'package:bioplus/ui/edec_forms/view/edec_forms_page.dart';
import 'package:bioplus/ui/emergency_warning_page/view/emergency_warning_page_page.dart';
import 'package:bioplus/ui/envd/cubit/graphql_client.dart';
import 'package:bioplus/ui/links_page/links_page.dart';
import 'package:bioplus/ui/maps/view/maps_page.dart';
import 'package:bioplus/ui/records/records_page.dart';
import 'package:bioplus/ui/select_role/view/select_role_page.dart';
import 'package:bioplus/ui/sos_warning/sos_warning.dart';
import 'package:bioplus/ui/visitors/visitors_page.dart';
import 'package:bioplus/ui/work_safety/view/work_safety_page.dart';
import 'package:bioplus/widgets/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/// {@template dashboard_body}
/// Body of the DashboardPage.
///
/// Add what it does
/// {@endtemplate}
class DashboardBody extends StatelessWidget {
  /// {@macro dashboard_body}
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardNotifier>(
      builder: (context, state, child) {
        // print('is role visitor: ${state.isVisitor}');
        return GridView(
          // shrinkWrap: true,
          // primary: false,
          // physics: const NeverScrollableScrollPhysics(),
          padding: kPadding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: kPadding.left.h,
            crossAxisSpacing: kPadding.left.w,
          ),
          children: [
            DashboardCard(
              text: 'Visitors',
              image: 'assets/icons/Check In.png',
              onTap: () => Get.to(() => const VisitorsPage()),
            ),
            DashboardCard(
              text: 'SOS',
              iconData: Icons.emergency_outlined,
              image: 'assets/icons/SOS icon.png',
              onTap: () => DialogService.showDialog(
                child: const DialogLayout(child: SosWarningPage()),
              ),
            ),
            DashboardCard(
              text: 'My Location',
              image: 'assets/icons/Geofences (1).png',
              onTap: () => Get.to(() => const MapsPage()),
            ),
            if (!state.isVisitor)
              DashboardCard(
                text: 'EMERGENCY WARNING!'.capitalize!,
                image: 'assets/icons/warning_icon.png',
                onTap: () {
                  Get.to(() => const EmergencyWarningPagePage());
                },
              ),
            DashboardCard(
              text: 'My Records',
              image: 'assets/icons/edit.png',
              onTap: () async {
                Get.to(() => const RecordsPage());
              },
            ),
            if (!state.isVisitor)
              DashboardCard(
                text: 'My eDEC\nForms',
                image: 'assets/icons/eDEC forms.png',
                onTap: () {
                  Get.to(() => const EdecFormsPage());
                },
              ),
            DashboardCard(
              text: 'Links',
              image: 'assets/icons/Links.png',
              onTap: () => Get.to(() => const LinksPage()),
            ),
            if (ApiConstants.isDegugMode)
              DashboardCard(
                text: 'My Waybill',
                image: 'assets/icons/eNVD.jpg',
                size: 65.w,
                onTap: () async {
                  final client = GraphQlClient(userData: state.userData!);
                  await client.redirect();
                },
              ),
            DashboardCard(
              text: 'Work Safety',
              image: 'assets/icons/Work Safety.png',
              onTap: () {
                Get.to(() => const WorkSafetyPage());
              },
            ),
            DashboardCard(
              text: 'Service role settings'.capitalize!,
              image: 'assets/icons/settings.png',
              onTap: () => Get.to(
                const SelectRolePage(showBackArrow: true),
              ),
            ),
          ],
        );
      },
    );
  }
}
