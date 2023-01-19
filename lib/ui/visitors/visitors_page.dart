import 'package:bioplus/ui/visitor_check_in/view/visitor_check_in_page.dart';
import 'package:flutter/material.dart';

class VisitorsPage extends StatefulWidget {
  const VisitorsPage({super.key});

  @override
  State<VisitorsPage> createState() => _VisitorsPageState();
}

class _VisitorsPageState extends State<VisitorsPage> {
  @override
  Widget build(BuildContext context) {
    return const VisitorCheckInPage();

    //   return DefaultTabController(
    //     length: 2,
    //     child: Scaffold(
    //       appBar: MyAppBar(
    //         backgroundColor: kPrimaryColor,
    //         title: const Text(
    //           'Visitors',
    //         ),
    //         // bottom: TabBar(
    //         //   tabs: <Widget>[
    //         //     Tab(
    //         //       icon: Image.asset(
    //         //         'assets/icons/Check In.png',
    //         //       ),
    //         //     ),
    //         //     Tab(
    //         //       icon: Icon(Icons.beach_access_sharp),
    //         //     ),
    //         //   ],
    //         // ),
    //       ),
    //       body: Padding(
    //         padding: kPadding,
    //         child: Column(
    //           children: <Widget>[
    //             // VisitorCheckInPage(),
    //             // LogbookPage(),
    //             MyListTile(
    //               text: 'Visitor Check-Ins',
    //               style: TextStyle(
    //                 fontSize: 18.sp,
    //               ),
    //               onTap: () async {
    //                 Get.to(() => VisitorCheckInPage());
    //               },
    //             ),
    //             // Gap(25.h),
    //             // MyListTile(
    //             //   text: 'Visitor Logbook',
    //             //   style: TextStyle(
    //             //     fontSize: 18.sp,
    //             //   ),
    //             //   onTap: () async {
    //             //     Get.to(() => LogbookPage());
    //             //   },
    //             // )
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
  }
}
