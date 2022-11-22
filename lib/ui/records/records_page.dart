import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/cvd_forms/view/cvd_forms.dart';
import 'package:background_location/view_sent_notification/view_sent_notification.dart';
import 'package:background_location/widgets/my_listTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../widgets/my_appbar.dart';
import '../admin/pages/visitor_log_book/view/logbook_page.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({Key? key}) : super(key: key);

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: const Text(Strings.records),
        elevation: 5,
      ),
      body: ListView(
        padding: kPadding,
        children: [
          MyListTile(
            text: Strings.cvdForms,
            style: TextStyle(
              fontSize: 18.sp,
            ),
            onTap: () async {
              Get.to(() => CvdForms());
            },
          ),
          Gap(20.h),
          MyListTile(
            text: 'Visitor Logbook',
            style: TextStyle(
              fontSize: 18.sp,
            ),
            onTap: () async {
              Get.to(() => LogbookPage());
            },
          ),
          Gap(20.h),
          MyListTile(
            text: 'Emergency Notifications',
            style: TextStyle(
              fontSize: 18.sp,
            ),
            onTap: () async {
              Get.to(() => ViewSentNotificationPage());
            },
          )
        ],
      ),
    );
  }
}
