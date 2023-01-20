import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/admin/pages/visitor_log_book/view/logbook_page.dart';
import 'package:bioplus/ui/cvd_record/cvd_record.dart';
import 'package:bioplus/ui/sos/sos.dart';
import 'package:bioplus/view_sent_notification/view_sent_notification.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:bioplus/widgets/my_listTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text(Strings.records),
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
              Get.to(() => const CvdRecordPage());
            },
          ),
          Gap(20.h),
          MyListTile(
            text: 'Visitor Logbook',
            style: TextStyle(
              fontSize: 18.sp,
            ),
            onTap: () async {
              Get.to(() => const LogbookPage());
            },
          ),
          Gap(20.h),
          MyListTile(
            text: 'Emergency Notifications',
            style: TextStyle(
              fontSize: 18.sp,
            ),
            onTap: () async {
              Get.to(() => const ViewSentNotificationPage());
            },
          ),
          Gap(20.h),
          MyListTile(
            text: Strings.sosRecords,
            style: TextStyle(
              fontSize: 18.sp,
            ),
            onTap: () async {
              Get.to(() => const SosPage());
            },
          )
        ],
      ),
    );
  }
}
