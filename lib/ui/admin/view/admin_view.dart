import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/admin/cubit/admin_cubit.dart';
import 'package:bioplus/ui/admin/pages/users_list/view/users_page.dart';
import 'package:bioplus/ui/admin/pages/visitor_log_book/view/logbook_page.dart';
import 'package:bioplus/ui/forms/forms_page.dart';
import 'package:bioplus/ui/forms/warakirri_entry_form/view/warakirri_entry_form_page.dart';
import 'package:bioplus/ui/maps/models/polygon_model.dart';
import 'package:bioplus/ui/maps/view/maps_page.dart';
import 'package:bioplus/ui/select_role/view/select_role_page.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/biosecure_logo.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:bioplus/widgets/my_listTile.dart';
import 'package:bioplus/widgets/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                Center(child: const AppLogo()),
                MyListTile(
                  text: 'Users',
                  onTap: () async => Get.to(() => const UsersPage()),
                ),
                MyListTile(
                  text: 'Visitor Log Books',
                  onTap: () async => Get.to(() => const LogbookPage()),
                ),
                MyListTile(
                  text: 'Locations',
                  onTap: () async {
                    Get.to(() => MapsPage());
                  },
                ),
                MyListTile(
                  text: 'Service Roles',
                  onTap: () async {
                    await Get.to(
                      () => const SelectRolePage(
                        showBackArrow: true,
                      ),
                    );
                  },
                ),
                MyListTile(
                  text: 'Price List',
                  onTap: () async {
                    await Get.to(
                      () => const PdfViewer(
                        path: 'assets/terms_and_conditions/BIOPLUS Price List 19122022.pdf',
                        title: 'Price List',
                      ),
                    );
                  },
                ),
                // MyListTile(
                //   text: 'Consignee',
                //   onTap: () async {},
                // ),
                // MyListTile(
                //   text: 'eNVD',
                //   onTap: () async {
                //     // Get.to
                //   },
                // ),
                // MyListTile(
                //   text: 'Mapping',
                //   onTap: () async {},
                // ),
                MyListTile(
                  text: 'Global Declaration Form',
                  onTap: () async {
                    Get.to(
                      () {
                        final api = context.read<Api>();
                        final id = api.logbookRecords.isNotEmpty ? api.logbookRecords.first.id : 0;
                        return FormsPage(zoneId: id.toString());
                      },
                    );
                  },
                ),
                MyListTile(
                  text: 'Warakirri Declaration Form',
                  onTap: () async {
                    Get.to(
                      () => WarakirriEntryFormPage(
                        zoneId: '88',
                        polygon: PolygonModel(
                          color: Colors.red,
                          name: 'Test zone',
                          points: [],
                        ),
                      ),
                    );
                  },
                ),

                MyListTile(
                  text: 'Exit All Zones',
                  onTap: () async {
                    try {
                      final api = context.read<Api>();
                      final userId = api.getUserData()!.id;
                      final recordsCreatedByCurrentUser =
                          api.logbookRecords.where((element) => element.user!.id == userId);
                      final loggedInZones = recordsCreatedByCurrentUser.where((element) => element.exitDate == null);
                      final futures = loggedInZones.map((e) => api.markExitById(e.id.toString()));
                      await Future.wait(futures);
                    } catch (e) {
                      print(e);
                    }
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
