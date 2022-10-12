import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/view/logbook_page.dart';
import 'package:background_location/ui/cvd_form/view/cvd_from_page.dart';
import 'package:background_location/ui/dashboard/dashboard_card.dart';
import 'package:background_location/ui/maps/view/maps_page.dart';
import 'package:background_location/ui/select_role/view/select_role_page.dart';
import 'package:background_location/ui/visitor_check_in/view/visitor_check_in_page.dart';
import 'package:background_location/widgets/dialogs/coming_soon.dart';
import 'package:background_location/widgets/dialogs/dialog_layout.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../links_page/links_page.dart';

class DashboardView extends StatelessWidget {
  final bool fromDrawer;
  const DashboardView({Key? key, this.fromDrawer = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     context.read<MapsRepo>().logBookEntry(
        //           context.read<Api>( ).getUserData()!.pic!,
        //           null,
        //           '35',
        //         );
        //   },
        // ),
        appBar: const MyAppBar(
          showBackButton: false,
          centreTitle: true,
          // title: _logo(),
        ),
        body: SingleChildScrollView(
          child: Column(
            // alignment: Alignment.center,
            children: [
              Gap(10.h),
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
                physics: const NeverScrollableScrollPhysics(),
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
                    onTap: () => Get.to(() => const LogbookPage()),
                  ),
                  DashboardCard(
                    text: Strings.geofences.toUpperCase(),
                    iconData: Icons.fence,
                    onTap: () => Get.to(() => const MapsPage()),
                  ),
                  DashboardCard(
                    text: Strings.settings.toUpperCase(),
                    iconData: Icons.settings,
                    onTap: () => Get.to(
                      // () => SettingsPage(
                      //   showBackbutton: true,
                      // ),
                      const SelectRolePage(
                        showBackArrow: true,
                      ),
                    ),
                  ),
                  DashboardCard(
                    text: Strings.envds,
                    iconData: Icons.person,
                    onTap: () => DialogService.showDialog(child: const ComingSoonDialog()),
                  ),
                  // DashboardCard(
                  //   text: Strings.selectYourRole,
                  //   iconData: Icons.person,
                  //   onTap: () => Get.to(() => const SelectRolesRegistrationPage()),
                  // ),
                  DashboardCard(
                    text: Strings.links.toUpperCase(),
                    iconData: Icons.link,
                    onTap: () => Get.to(() => const LinksPage()),
                  ),
                  DashboardCard(
                    text: Strings.visitorCheckIn.toUpperCase(),
                    iconData: Icons.token_rounded,
                    onTap: () => Get.to(() => const VisitorCheckInPage()),
                  ),
                  DashboardCard(
                    text: 'eDEC Forms',
                    iconData: Icons.format_list_bulleted_sharp,
                    onTap: () {
                      DialogService.showDialog(child: const ComingSoonDialog());
                    },
                    // onTap: () => Get.to(() => VisitorCheckInPage()),
                  ),
                  DashboardCard(
                    text: 'CVD FORM',
                    iconData: Icons.format_align_justify_rounded,
                    onTap: () => Get.to(() => const CvdFormPage()),
                  ),
                  DashboardCard(
                    text: 'WORK SAFETY',
                    iconData: Icons.work_outline,
                    onTap: () {
                      DialogService.showDialog(child: const ComingSoonDialog());
                    },
                  ),
                  // DashboardCard(
                  //   text: 'Global Form',
                  //   iconData: Icons.work_outline,
                  //   onTap: () {
                  //     // DialogService.showDialog(child: const ComingSoonDialog());
                  //     Get.to(() => GlobalQuestionnaireForm());
                  //   },
                  // ),
                  DashboardCard(
                    text: 'EMERGENCY WARNING!',
                    // iconData: LineIcons.info,
                    // color: Colors.yellow,
                    // iconData: Icons.info,
                    // imagecolor: null,
                    image: 'assets/icons/warning_icon.png',
                    onTap: () {
                      _warningDialog();
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
      ),
    );
  }

  _warningDialog() async {
    DialogService.showDialog(
      child: DialogLayout(
        child: Padding(
          padding: kPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // alert text
              Image.asset(
                'assets/icons/warning_icon.png',
                height: 20.height,
              ),
              Gap(10.h),
              Text(
                'Are you sure you want to send this WARNING alert?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // yes no buttons
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Spacer(),
                  // yes button
                  Gap(20.w),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        await DialogService.showDialog(child: const ComingSoonDialog());
                      },
                      child: const Text('Yes'),
                    ),
                  ),
                  Gap(10.w),

                  // no button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async => Get.back(),
                      child: const Text('No'),
                    ),
                  ),
                  Gap(20.w),

                  // Gap(10.w),
                ],
              ),
            ],
          ),
        ),
      ),
      // child: ErrorDialog(
      //   message: 'Are you sure you want to send this WARNING alert?',
      //   onTap: Get.back,
      // ),
    );
  }

  Row _logo() {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Gap(20.h),
        Image.asset(
          'assets/icons/BIO_shield1 (1).png',
          height: 7.height,
        ),
        Text(
          'BIO',
          style: TextStyle(
            color: const Color(0xff3B4798),
            fontWeight: FontWeight.bold,
            fontSize: 20.w,
          ),
        ),
        Text(
          'SECURE',
          style: TextStyle(
            color: const Color(0xff75B950),
            fontWeight: FontWeight.bold,
            fontSize: 20.w,
          ),
        ),
      ],
    );
  }
}
