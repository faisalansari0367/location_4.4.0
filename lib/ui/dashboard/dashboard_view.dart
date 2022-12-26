import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/services/notifications/sync_service.dart';
import 'package:bioplus/ui/dashboard/dashboard_card.dart';
import 'package:bioplus/ui/edec_forms/view/edec_forms_page.dart';
import 'package:bioplus/ui/emergency_warning_page/view/emergency_warning_page_page.dart';
import 'package:bioplus/ui/maps/location_service/maps_repo.dart';
import 'package:bioplus/ui/maps/view/maps_page.dart';
import 'package:bioplus/ui/records/records_page.dart';
import 'package:bioplus/ui/select_role/view/select_role_page.dart';
import 'package:bioplus/ui/sos_warning/view/sos_warning_page.dart';
import 'package:bioplus/ui/visitors/visitors_page.dart';
import 'package:bioplus/ui/work_safety/view/work_safety_page.dart';
import 'package:bioplus/widgets/dialogs/dialog_layout.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/logo/app_name_widget.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../services/notifications/push_notifications.dart';
import '../../widgets/dialogs/status_dialog_new.dart';
import '../envd/cubit/graphql_client.dart';
import '../envd/view/evnd_page.dart';
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

  @override
  void didUpdateWidget(covariant DashboardView oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  void _init() async {
    final api = context.read<Api>();
    final localApi = context.read<LocalApi>();
    if (api.isInit) {
      return;
    }
    api.setIsInit(true);
    SyncService().init(localApi, api);

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
            height: 50,
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
                  // mainAxisSpacing: 20,
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
                    text: 'My Location',
                    image: 'assets/icons/Geofences (1).png',
                    onTap: () => Get.to(() => const MapsPage()),
                  ),
                  if (!isVisitor)
                    DashboardCard(
                      text: 'EMERGENCY WARNING!'.capitalize!,
                      image: 'assets/icons/warning_icon.png',
                      onTap: () {
                        Get.to(() => EmergencyWarningPagePage());
                      },
                    ),
                  DashboardCard(
                    text: 'My Records',
                    image: 'assets/icons/edit.png',
                    onTap: () async {
                      Get.to(() => const RecordsPage());
                    },
                  ),
                  if (!isVisitor)
                    DashboardCard(
                      text: 'My eDEC\nForms',
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
                  if (ApiConstants.baseUrl == ApiConstants.localUrl)
                    DashboardCard(
                      text: 'My Waybill',
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

  Widget _logo() {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icons/BIO_shield1 (1).png',
            // height: 7.height,
            height: 150,
          ),
          Gap(5.w),
          LimitedBox(child: AppName()),
        ],
      ),
    );
  }
}
