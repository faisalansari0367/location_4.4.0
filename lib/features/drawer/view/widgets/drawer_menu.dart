import 'package:api_repo/api_repo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/features/drawer/models/drawer_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(15.height),
        // Spacer(),
        _buildWelcome(context),
        Gap(10.height),
        Gap(2.height),
        ..._drawerItems.items.map(_customTile).toList(),
        // Gap(2.height),
        // Spacer(),
        // Spacer(),
        Gap(30.height),

        Padding(
          padding: kPadding,
          child: SizedBox(
            width: 50.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCopyright(context),
                if (packageInfo != null) _buildVersion(),
              ],
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }

  Padding _buildWelcome(BuildContext context) {
    final style = Theme.of(context).textTheme.headline6?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 24.sp,
        );
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Welcome',
                style: style,
              ),
              Gap(10.w),
              Container(
                decoration: MyDecoration.decoration(),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                child: Text(
                  user?.role ?? '',
                  style: context.textTheme.bodyText2?.copyWith(
                    color: context.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          Text(
            user?.fullName ?? '',
            style: style,
          ),
        ],
      ),
    );
  }

  Widget _buildCopyright(BuildContext context) {
    return Text(
      'Copyright ${DateTime.now().year}',
      style: Theme.of(context).textTheme.headline6?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18.h,
          ),
    );
  }

  Widget _buildVersion() {
    return Text(
      'Version ${packageInfo?.version}',
      style: TextStyle(
        color: Color.fromARGB(235, 255, 255, 255),
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
      ),
    );
  }

  Widget _leading(String? image, Color color, IconData iconData) {
    final size = 22.0;
    return image != null
        ? Image.asset(
            image,
            color: color,
            height: size,
          )
        : Icon(
            iconData,
            color: color,
            size: size,
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
            topRight: Radius.circular(50),
            bottomRight: Radius.circular(50),
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
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w500,
                fontSize: 18.sp,
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
