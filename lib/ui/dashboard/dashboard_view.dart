import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/dashboard/dashboard_card.dart';
import 'package:background_location/ui/edec_forms/view/edec_forms_page.dart';
import 'package:background_location/ui/emergency_warning_page/view/emergency_warning_page_page.dart';
import 'package:background_location/ui/envd/cubit/graphql_client.dart';
import 'package:background_location/ui/envd/view/evnd_page.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/maps/view/maps_page.dart';
import 'package:background_location/ui/records/records_page.dart';
import 'package:background_location/ui/select_role/view/select_role_page.dart';
import 'package:background_location/ui/sos_warning/view/sos_warning_page.dart';
import 'package:background_location/ui/visitors/visitors_page.dart';
import 'package:background_location/ui/work_safety/view/work_safety_page.dart';
import 'package:background_location/widgets/dialogs/dialog_layout.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:background_location/widgets/dialogs/status_dialog_new.dart';
import 'package:background_location/widgets/logo/app_name_widget.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../services/notifications/push_notifications.dart';
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
    if (api.isInit) {
      return;
    }
    api.setIsInit(true);

    final mapsApi = context.read<MapsRepo>();
    final notificationService = context.read<PushNotificationService>();
    final user = api.getUser()!;
    user.registerationToken = await notificationService.getFCMtoken();

    await api.updateMe(user: user);

    await mapsApi.getAllPolygon();

    api.getLogbookRecords();
  }

  @override
  Widget build(BuildContext context) {
    final isVisitor = context.read<Api>().getUser()?.role == 'Visitor';
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: MyAppBar(
          showBackButton: false,
          centreTitle: true,
          title: SizedBox(
            height: 50.h,
            child: AnimationConfiguration.synchronized(
              child: ScaleAnimation(
                scale: 0.7,
                curve: Curves.easeIn,
                child: _logo(),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
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
                    image: 'assets/icons/Check In.png',
                    onTap: () => Get.to(() => const VisitorsPage()),
                  ),
                  DashboardCard(
                    text: 'SOS',
                    iconData: Icons.emergency_outlined,
                    image: 'assets/icons/SOS icon.png',
                    onTap: () => DialogService.showDialog(child: DialogLayout(child: SosWarningPage())),
                  ),
                  DashboardCard(
                    text: 'Location',
                    image: 'assets/icons/Geofences (1).png',
                    onTap: () => Get.to(() => const MapsPage()),
                  ),
                  DashboardCard(
                    text: 'EMERGENCY WARNING!'.capitalize!,
                    image: 'assets/icons/warning_icon.png',
                    onTap: () {
                      Get.to(() => EmergencyWarningPagePage());
                    },
                  ),
                  DashboardCard(
                    text: Strings.records,
                    image: 'assets/icons/edit.png',
                    onTap: () async {
                      Get.to(() => const RecordsPage());
                    },
                  ),
                  if (!isVisitor)
                    DashboardCard(
                      text: 'eDEC Forms',
                      image: 'assets/icons/eDEC forms.png',
                      onTap: () {
                        Get.to(() => EdecFormsPage());
                      },
                    ),
                  DashboardCard(
                    text: 'Links',
                    image: 'assets/icons/Links.png',
                    onTap: () => Get.to(() => const LinksPage()),
                  ),
                  if (!isVisitor)
                    DashboardCard(
                      text: Strings.envds,
                      image: 'assets/icons/eNVD.jpg',
                      size: 65.w,
                      onTap: () async {
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
                      },
                    ),
                  DashboardCard(
                    text: 'Work Safety',
                    image: 'assets/icons/Work Safety.png',
                    onTap: () {
                      Get.to(() => WorkSafetyPage());
                    },
                  ),
                  DashboardCard(
                    text: ('Service role settings').capitalize!,
                    image: 'assets/icons/settings.png',
                    onTap: () => Get.to(
                      const SelectRolePage(
                        showBackArrow: true,
                      ),
                    ),
                  ),
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
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icons/BIO_shield1 (1).png',
          height: 7.height,
        ),
        Gap(5.w),
        AppName(),
      ],
    );
  }
}
