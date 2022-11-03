import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/admin/cubit/admin_cubit.dart';
import 'package:background_location/ui/admin/pages/users_list/view/users_page.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/view/logbook_page.dart';
import 'package:background_location/ui/forms/view/global_questionnaire_form.dart';
import 'package:background_location/ui/maps/view/maps_page.dart';
import 'package:background_location/ui/select_role/view/select_role_page.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/biosecure_logo.dart';
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
      appBar: const MyAppBar(
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
              children: [
                const BioSecureLogo(),
                MyListTile(
                  text: 'Users',
                  onTap: () async => Get.to(() => const UsersPage()),
                ),
                MyListTile(
                  text: 'Visitor Log Books',
                  onTap: () async => Get.to(() => const LogbookPage()),
                ),
                MyListTile(
                  text: 'Geofences',
                  onTap: () async {
                    await Get.to(() => const MapsPage());
                  },
                ),
                MyListTile(
                  text: 'Settings',
                  onTap: () async {
                    await Get.to(
                      () => const SelectRolePage(
                        showBackArrow: true,
                      ),
                    );
                  },
                ),
                MyListTile(
                  text: 'Transporters',
                  onTap: () async {},
                ),
                MyListTile(
                  text: 'Consignee',
                  onTap: () async {},
                ),
                MyListTile(
                  text: 'eNVD',
                  onTap: () async {},
                ),
                MyListTile(
                  text: 'Mapping',
                  onTap: () async {},
                ),
                MyListTile(
                  text: 'Global Declaration Form',
                  onTap: () async {
                    Get.to(() => GlobalQuestionnaireForm(zoneId: '85'));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
