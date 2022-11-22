import 'package:api_repo/api_repo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/features/drawer/models/drawer_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../constants/constans.dart';
import '../../../../constants/strings.dart';
import '../../cubit/my_drawer_controller.dart';
import '../../models/drawer_item.dart';

class DrawerMenu extends StatefulWidget {
  // final List<DrawerItem> items;
  final Function(int) onItemSelected;
  final int selectedIndex;

  const DrawerMenu({Key? key, required this.onItemSelected, required this.selectedIndex}) : super(key: key);

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  PackageInfo? packageInfo;
  late DrawerItems _drawerItems;
  User? user;

  @override
  void initState() {
    _init();
    final api = context.read<Api>();
    user = api.getUser();
    final drawer = context.read<DrawerCubit>();
    _drawerItems = DrawerItems(api, drawer: drawer);
    super.initState();
  }

  Future<void> _init() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: kPadding.copyWith(left: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(20.height),
          // Padding(
          //   padding: EdgeInsets.only(
          //     left: 40.w,
          //   ),
          //   child: Image.asset(
          //     Assets.icons.appIcon.path,
          //     height: 14.height,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome\n${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 24.sp,
                      ),
                ),
                Gap(25.h),
                // Divider(
                //     // color: Colors.white,
                //     ),
                Row(
                  children: [
                    Gap(5.w),
                    Icon(
                      Icons.account_box_outlined,
                      color: Colors.white,
                      size: 25.h,
                    ),
                    Gap(10.w),
                    Text(
                      '${user?.role ?? ''}',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.h,
                          ),
                    ),
                  ],
                ),
                Gap(10.h),
              ],
            ),
          ),

          ..._drawerItems.items.map(_customTile).toList(),
          // Spacer(),
          if (packageInfo != null)
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.build,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  Gap(10.w),
                  Text(
                    'Version ${packageInfo?.version}',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _leading(String? image, Color color, IconData iconData) {
    return image != null
        ? Image.asset(
            image,
            color: color,
            height: 25,
          )
        : Icon(
            iconData,
            color: color,
          );
  }

  Widget _customTile(DrawerItem item) {
    final isSelected = widget.selectedIndex == _drawerItems.items.indexOf(item);
    final color = isSelected ? Colors.black : Colors.white;
    final image = item.image;
    final iconData = item.iconData;
    return GestureDetector(
      onTap: () async {
        if (item.onTap != null) item.onTap!();
        if (item.text == Strings.logout) {
          return;
        }
        widget.onItemSelected(_drawerItems.items.indexOf(item));
        // await 100.milliseconds.delay();
      },
      child: AnimatedContainer(
        duration: 200.milliseconds,
        width: 50.width,
        curve: Curves.easeIn,
        padding: kPadding.copyWith(bottom: 15.h, top: 15.h),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          color: isSelected ? Colors.white : Colors.transparent,
        ),
        child: Row(
          children: [
            _leading(image, color, iconData),
            Gap(3.width),
            AnimatedDefaultTextStyle(
              duration: 100.milliseconds,
              style: TextStyle(
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w600,
                fontSize: 20.sp,
              ),
              child: Flexible(
                child: AutoSizeText(
                  item.text,
                  maxLines: 1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
