import 'package:background_location/extensions/size_config.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../constants/constans.dart';
import '../../../../constants/strings.dart';
import '../../models/drawer_item.dart';

class DrawerMenu extends StatelessWidget {
  final List<DrawerItem> items;
  final Function(int) onItemSelected;
  final int selectedIndex;

  const DrawerMenu({Key? key, required this.items, required this.onItemSelected, required this.selectedIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: kPadding.copyWith(left: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [...items.map(_customTile).toList()],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(DrawerItem item) {
    final isSelected = selectedIndex == items.indexOf(item);
    final color = isSelected ? Colors.white : Colors.white70;
    final image = item.image;
    final iconData = item.iconData;
    return ListTile(
      // leading: Icon(item.iconData, color: color),
      selectedColor: Colors.white,
      selectedTileColor: Colors.white,
      tileColor: Colors.white,
      leading: _leading(image, color, iconData),
      title: Text(
        item.text,
        style: TextStyle(
          color: color,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      selected: selectedIndex == item.page,
      onTap: () {
        if (item.onTap != null) item.onTap!();
        onItemSelected(items.indexOf(item));
      },
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
    final isSelected = selectedIndex == items.indexOf(item);
    final color = isSelected ? Colors.black : Colors.white70;
    final image = item.image;
    final iconData = item.iconData;
    return GestureDetector(
      onTap: () async {
        if (item.onTap != null) item.onTap!();
        if (item.text == Strings.logout) {
          return;
        }
        onItemSelected(items.indexOf(item));
        // await 100.milliseconds.delay();
      },
      child: AnimatedContainer(
        duration: 200.milliseconds,
        width: 50.width,
        curve: Curves.easeIn,
        // padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
        padding: kPadding.copyWith(
          bottom: 15,
          top: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          color: isSelected ? Colors.white : Colors.transparent,
        ),
        child: Row(
          children: [
            _leading(image, color, iconData),
            Gap(3.width),
            Text(
              item.text,
              style: TextStyle(
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
