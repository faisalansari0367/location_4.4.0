import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/dashboard/dashboard_card.dart';
import 'package:background_location/ui/edec_forms/view/edec_forms_page.dart';
import 'package:background_location/ui/emergency_warning/emergency_warning.dart';
import 'package:background_location/ui/envd/cubit/graphql_client.dart';
import 'package:background_location/ui/envd/view/evnd_page.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/maps/view/maps_page.dart';
import 'package:background_location/ui/records/records_page.dart';
import 'package:background_location/ui/select_role/view/select_role_page.dart';
import 'package:background_location/ui/visitors/visitors_page.dart';
import 'package:background_location/widgets/dialogs/coming_soon.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:background_location/widgets/dialogs/status_dialog_new.dart';
import 'package:background_location/widgets/logo/app_name_widget.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../links_page/links_page.dart';

class DashboardView extends StatefulWidget {
  final bool fromDrawer;
  const DashboardView({Key? key, this.fromDrawer = false}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    final api = context.read<Api>();
    final mapsApi = context.read<MapsRepo>();

    final hasNoLogRecords = api.logbookRecords.isEmpty;
    if (!mapsApi.hasPolygons) {
      await mapsApi.getAllPolygon();
    }
    if (hasNoLogRecords) {
      api.getLogbookRecords();
    }
  }

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
        appBar: MyAppBar(
          showBackButton: false,
          centreTitle: true,

          // backgroundColor: Colors.red,
          title: SizedBox(
            height: 50.h,
            child: _logo(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            // alignment: Alignment.center,
            children: [
              // Gap(10.h),
              // _logo(),
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
                    text: 'Visitors',
                    // iconData: Icons.qr_code,
                    image: 'assets/icons/Check In.png',
                    onTap: () => Get.to(() => const VisitorsPage()),
                  ),
                  // DashboardCard(
                  //   text: 'Visitor Check-Ins',
                  //   // iconData: Icons.qr_code,
                  //   image: 'assets/icons/Check In.png',
                  //   onTap: () => Get.to(() => const VisitorCheckInPage()),
                  // ),
                  DashboardCard(
                    text: 'Work Safety',
                    // iconData: Icons.work_outline,
                    image: 'assets/icons/Work Safety.png',
                    onTap: () {
                      DialogService.showDialog(child: const ComingSoonDialog());
                    },
                  ),
                  DashboardCard(
                    text: 'Links',
                    // iconData: Icons.link,
                    image: 'assets/icons/Links.png',
                    onTap: () => Get.to(() => const LinksPage()),
                  ),
                  DashboardCard(
                    text: 'EMERGENCY WARNING!'.capitalize!,
                    // iconData: LineIcons.info,
                    // color: Colors.yellow,
                    // iconData: Icons.info,
                    // imagecolor: null,
                    image: 'assets/icons/warning_icon.png',
                    onTap: () {
                      // _warningDialog(context);
                      Get.to(() => EmergencyWarning());
                    },
                  ),
                  DashboardCard(
                    text: 'Location',
                    // iconData: Icons.fence,
                    image: 'assets/icons/Geofences (1).png',
                    onTap: () => Get.to(() => const MapsPage()),
                  ),
                  DashboardCard(
                    text: Strings.envds,
                    // iconData: Icons.person,
                    image: 'assets/icons/eNVD.jpg',
                    size: 65.w,

                    onTap: () async {
                      // context.read<Api>().getEnvdToken();
                      final client = GraphQlClient(userData: context.read<Api>().getUserData()!);
                      final isInit = await client.init();

                      if (!client.hasCredentials()) {
                        final message =
                            "Please provide valid LPA credentials in your role settings to use this feature.";
                        Get.dialog(
                          StatusDialog(
                            lottieAsset: 'assets/animations/error.json',
                            message: message,
                            onContinue: () async {
                              Get.back();
                              Get.to(
                                () => const SelectRolePage(
                                  showBackArrow: true,
                                ),
                              );
                            },
                          ),
                        );
                        return;
                      }

                      if (isInit) {
                        Get.to(() => const EnvdPage());
                      } else {
                        DialogService.error(
                          "Unable to connect with the ISC server currently. Please try again later.",
                        );
                      }
                      // DialogService.showDialog(child: const ComingSoonDialog());
                    },
                  ),

                  DashboardCard(
                    text: Strings.records,
                    // iconData: Icons.format_align_justify_rounded,
                    image: 'assets/icons/edit.png',
                    // onTap: () => Get.to(() => const CvdFormPage()),
                    onTap: () async {
                      // DialogService.showDialog(child: const ComingSoonDialog());

                      Get.to(() => const RecordsPage());
                      // Get.back();
                    },
                  ),

                  // DashboardCard(
                  //   text: Strings.selectYourRole,
                  //   iconData: Icons.person,
                  //   onTap: () => Get.to(() => const SelectRolesRegistrationPage()),
                  // ),

                  DashboardCard(
                    text: 'eDEC Forms',
                    // iconData: Icons.format_list_bulleted_sharp,
                    image: 'assets/icons/eDEC forms.png',
                    onTap: () {
                      Get.to(() => EdecFormsPage());
                    },
                    // onTap: () => Get.to(() => VisitorCheckInPage()),
                  ),
                  // DashboardCard(
                  //   text: Strings.visitorLogBook.capitalize!,
                  //   // iconData: Icons.book,
                  //   image: 'assets/icons/Logbook.jpg',
                  //   onTap: () => Get.to(() => const LogbookPage()),
                  // ),
                  DashboardCard(
                    text: Strings.settings.capitalize!,
                    // iconData: Icons.settings,
                    image: 'assets/icons/settings.png',
                    onTap: () => Get.to(
                      // () => SettingsPage(
                      //   showBackbutton: true,
                      // ),
                      const SelectRolePage(
                        showBackArrow: true,
                      ),
                    ),
                  ),

                  // DashboardCard(
                  //   text: 'Global Form',
                  //   iconData: Icons.work_outline,
                  //   onTap: () {
                  //     // DialogService.showDialog(child: const ComingSoonDialog());
                  //     Get.to(() => GlobalQuestionnaireForm());
                  //   },
                  // ),

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

  Row _logo() {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Gap(20.h),
        Image.asset(
          'assets/icons/BIO_shield1 (1).png',
          height: 7.height,
        ),
        Gap(5.w),
        AppName(),
        // Text(
        //   'BIO',
        //   style: TextStyle(
        //     color: const Color(0xff3B4798),
        //     fontWeight: FontWeight.bold,
        //     fontSize: 20.w,
        //   ),
        // ),
        // Text(
        //   'SECURE',
        //   style: TextStyle(
        //     color: const Color(0xff75B950),
        //     fontWeight: FontWeight.bold,
        //     fontSize: 20.w,
        //   ),
        // ),
      ],
    );
  }
}
