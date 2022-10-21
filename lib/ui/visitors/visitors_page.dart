import 'package:background_location/constants/index.dart';
import 'package:background_location/theme/color_constants.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/view/logbook_page.dart';
import 'package:background_location/ui/visitor_check_in/view/visitor_check_in_page.dart';
import 'package:background_location/widgets/my_listTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../widgets/my_appbar.dart';

class VisitorsPage extends StatefulWidget {
  const VisitorsPage({Key? key}) : super(key: key);

  @override
  State<VisitorsPage> createState() => _VisitorsPageState();
}

class _VisitorsPageState extends State<VisitorsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MyAppBar(
          backgroundColor: kPrimaryColor,
          title: const Text(
            'Visitors',
          ),
          // bottom: TabBar(
          //   tabs: <Widget>[
          //     Tab(
          //       icon: Image.asset(
          //         'assets/icons/Check In.png',
          //       ),
          //     ),
          //     Tab(
          //       icon: Icon(Icons.beach_access_sharp),
          //     ),
          //   ],
          // ),
        ),
        body: Padding(
          padding: kPadding,
          child: Column(
            children: <Widget>[
              // VisitorCheckInPage(),
              // LogbookPage(),
              MyListTile(
                text: 'Visitor Check-Ins',
                style: TextStyle(
                  fontSize: 18.sp,
                ),
                onTap: () async {
                  Get.to(() => VisitorCheckInPage());
                },
              ),
              Gap(25.h),
              MyListTile(
                text: 'Visitor Logbook',
                style: TextStyle(
                  fontSize: 18.sp,
                ),
                onTap: () async {
                  Get.to(() => LogbookPage());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}