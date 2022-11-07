import 'package:auto_size_text/auto_size_text.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/select_roles_registration/view/select_roles_registration_page.dart';
import 'package:background_location/widgets/listview/my_listview.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/my_listTile.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// import 'package:get/get.dart';

import '../cubit/select_role_cubit.dart';

class SelectRoleView extends StatelessWidget {
  final bool showBackArrow;
  const SelectRoleView({Key? key, this.showBackArrow = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SelectRoleCubit>();

    return Scaffold(
      appBar: MyAppBar(
        // elevation: 2,
        showBackButton: showBackArrow,
        title: BlocBuilder<SelectRoleCubit, SelectRoleState>(
          builder: (context, state) {
            return Text('Hi, ${state.user.firstName?.capitalize! ?? 'User'}');
          },
        ),
        // actions: [
        //   InkWell(
        //     onTap: () {
        //       cubit.api.logout();
        //       Get.offAll(() => SplashScreen());
        //     },
        //     child: Row(
        //       children: [
        //         Icon(Icons.exit_to_app),
        //         Gap(10.w),
        //         Text(
        //           'Logout',
        //           style: context.textTheme.subtitle2,
        //         ),
        //       ],
        //     ),
        //   ),
        //   Gap(10.w),
        // ],
      ),
      body: Container(
        color: context.theme.backgroundColor,
        padding: kPadding,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // padding: kPadding,
              children: [
                // Gap(10.height),
                Text(
                  // Strings.selectYourRole,
                  'Update Your Details\nor Select Additional Roles',
                  style: context.textTheme.headline5,
                ),
                Gap(2.height),
                BlocBuilder<SelectRoleCubit, SelectRoleState>(
                  builder: (context, state) {
                    return Expanded(
                      child: MyListview(
                        isLoading: state.isLoading,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => MyListTile(
                          text: state.roles[index].role,
                          onTap: () async => cubit.updateRole(
                            state.roles[index],
                          ),
                        ),
                        data: state.roles,
                        onRetry: cubit.getRoles,
                      ),
                    );
                  },
                ),

                Gap(2.height),
              ],
            ),
            BlocBuilder<SelectRoleCubit, SelectRoleState>(
              builder: (context, state) {
                return Visibility(
                  // visible: state.user.role! != 'Admin',
                  child: _selectRoleButton(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Positioned _selectRoleButton(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 3.width,
      right: 3.width,
      // width: 80.width,
      child: Container(
        padding: EdgeInsets.only(top: 15.w),
        decoration: MyDecoration.bottomButtonShadow(),
        child: Column(
          children: [
            AutoSizeText(
              'Hint: not found the role tap button to add new role',
              maxLines: 1,
              style: context.textTheme.subtitle2?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            Gap(5.h),
            MyElevatedButton(
              text: 'Select Role',
              onPressed: () async {
                Get.to(() => SelectRolesRegistrationPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
