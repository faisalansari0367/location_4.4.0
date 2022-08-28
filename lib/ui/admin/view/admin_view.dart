import 'package:background_location/constants/index.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/ui/admin/cubit/admin_cubit.dart';
import 'package:background_location/ui/admin/pages/users_list/view/users_page.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/view/logbook_page.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/my_listTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../cubit/admin_state.dart';

class AdminView extends StatelessWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        showBackButton: false,
        title: Text(
          'Welcome, Admin',
        ),
      ),
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: kPadding,
            child: AutoSpacing(
              spacing: Gap(2.5.height),
              // children: state.options
              //     .map(
              //       (e) => MyListTile(
              //           role: e,
              //           onTap: () async {
              //             Get.to(
              //               () => UsersList(),
              //             );
              //           }),
              //     )
              //     .toList(),
              children: [
                MyListTile(
                  role: 'Users',
                  onTap: () async => Get.to(() => UsersPage()),
                ),
                MyListTile(
                  role: 'Visitor Log Books',
                  onTap: () async => Get.to(() => LogbookPage()),
                ),
                MyListTile(
                  role: 'Geofences',
                  onTap: () async {},
                ),
                MyListTile(
                  role: 'Transporters',
                  onTap: () async {},
                ),
                MyListTile(
                  role: 'Consignee',
                  onTap: () async {},
                ),
                MyListTile(
                  role: 'eNVD',
                  onTap: () async {},
                ),
                MyListTile(
                  role: 'Mapping',
                  onTap: () async {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
