import 'package:background_location/constants/index.dart';
import 'package:background_location/gen/assets.gen.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/my_listTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: context.textTheme.headline6?.copyWith(
                fontSize: 40.h,
              ),
            ),
            Gap(50.h),
            MyListTile(
              text: 'About',
              onTap: () => DialogService.showDialog(
                child: AboutDialog(
                  applicationIcon: ClipRRect(
                    borderRadius: kBorderRadius,
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset(
                        Assets.icons.logo.path,
                      ),
                    ),
                  ),
                  applicationName: packageInfo?.appName,
                  applicationVersion: packageInfo?.version,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}