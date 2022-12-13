import 'dart:async';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/envd/cubit/graphql_client.dart';
import 'package:bioplus/ui/maps/location_service/background_location_service.dart';
import 'package:bioplus/ui/maps/location_service/maps_repo.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/dialogs/delete_dialog.dart';
import 'package:bioplus/widgets/dialogs/dialog_layout.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:bioplus/widgets/my_listTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

// import 'package:very_good_analysis/very_good_analysis.dart';

import '../../../gen/assets.gen.dart';
import '../../../widgets/pdf_viewer.dart';
import '../../login/view/login_page.dart';

class SettingsPage extends StatefulWidget {
  final bool showBackbutton;
  const SettingsPage({Key? key, this.showBackbutton = false}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PackageInfo? packageInfo;

  @override
  void initState() {
    _inti();
    super.initState();
  }

  _inti() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(showBackButton: widget.showBackbutton),
      body: SingleChildScrollView(
        padding: kPadding,
        child: AutoSpacing(
          children: [
            Text(
              'Settings',
              style: context.textTheme.headline6?.copyWith(
                fontSize: 40.h,
              ),
            ),
            // Gap(50.h),
            MyListTile(
              text: 'About',
              onTap: () async => unawaited(
                DialogService.showDialog(
                  // child: AboutDialog(
                  //   applicationIcon: ClipRRect(
                  //     borderRadius: kBorderRadius,
                  //     child: SizedBox(
                  //       height: 50,
                  //       width: 50,
                  //       child: Image.asset(
                  //         Assets.icons.appIcon.path,
                  //       ),
                  //     ),
                  //   ),
                  //   applicationName: packageInfo?.appName,
                  //   applicationVersion: packageInfo?.version,

                  // ),
                  child: DialogLayout(
                    child: Padding(
                      padding: kPadding,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AspectRatio(
                            // height: 50,
                            // width: 50,
                            aspectRatio: 4 / 3,
                            child: Image.asset(
                              Assets.icons.appIcon.path,
                            ),
                          ),
                          Gap(20.h),
                          Text(
                            packageInfo?.appName ?? '',
                            style: context.textTheme.headline5,
                          ),
                          if (ApiConstants.isDegugMode)
                            const Text(
                              ' (Debug)',
                              style: TextStyle(color: Colors.red),
                            ),
                          Gap(10.h),
                          Text(
                            Strings.appVersion,
                            style: context.textTheme.headline6,
                          ),
                          Gap(20.h),
                          MyElevatedButton(
                            text: 'Go back',
                            onPressed: () async => Get.back(),
                            width: 40.width,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            MyListTile(
              text: Strings.privacyPolicy,
              onTap: () async => Get.to(
                () => PdfViewer(
                  path: 'assets/terms_and_conditions/privacy_policy.pdf',
                  title: Strings.privacyPolicy,
                ),
              ),
            ),
            MyListTile(
              text: Strings.termsAndConditions,
              onTap: () async => Get.to(
                () => PdfViewer(
                  path:
                      'assets/terms_and_conditions/Terms  Conditions (EULA) - BioPlus mobile application 20112022.pdf',
                  title: Strings.termsAndConditions,
                ),
              ),
            ),
            MyListTile(
              onTap: () async {
                try {
                  DialogService.showDialog(
                    child: DeleteDialog(
                      msg: 'Are you sure you want to DELETE your account?',
                      onCancel: () {},
                      onConfirm: () async {
                        _deleteAccount();
                        // await Future.delayed(50.milliseconds);
                        // DialogService.success(
                        //   'Your account is now deleted and data removed from your device.',
                        //   onCancel: () async {
                        //     _deleteAccount();
                        //     await _logout(context);
                        //     Get.back();
                        //   },
                        // );
                      },
                    ),
                  );
                  // _deleteAccount();
                  // await _logout(context);
                } catch (e) {
                  print(e);
                }
              },
              text: 'Delete Your Account',
              trailing: const Icon(Icons.delete_forever),
            ),
            MyListTile(
              onTap: () async {
                try {
                  context.read<MapsRepo>().cancel();
                  context.read<GeofenceService>().cancel();
                  final client = GraphQlClient();
                  await client.clearStorage();
                  await context.read<Api>().logout();
                  await Get.offAll(() => const LoginPage());
                } catch (e) {
                  print(e);
                }
              },
              text: Strings.logout,
              trailing: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    context.read<MapsRepo>().cancel();
    context.read<GeofenceService>().cancel();
    final client = GraphQlClient();
    await client.clearStorage();
    await context.read<Api>().logout();
    await Get.offAll(() => const LoginPage());
  }

  void _deleteAccount() async {
    final api = context.read<Api>();
    final deleteUser = await api.deleteUser();
    deleteUser.when(
      success: (s) async {
        DialogService.success(
          s,
          onCancel: () async {
            await _logout(context);
            Get.back();
          },
        );
      },
      failure: ((error) => DialogService.failure(error: error)),
    );
  }
}
