import 'package:api_repo/api_repo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/select_role/cubit/select_role_cubit.dart';
import 'package:bioplus/ui/select_roles_registration/view/select_roles_registration_page.dart';
import 'package:bioplus/widgets/listview/my_listview.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:bioplus/widgets/my_listTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectRoleView extends StatelessWidget {
  final bool showBackArrow;
  const SelectRoleView({super.key, this.showBackArrow = false});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SelectRoleCubit>();

    return Scaffold(
      appBar: MyAppBar(
        showBackButton: showBackArrow,
        title: BlocBuilder<SelectRoleCubit, SelectRoleState>(
          builder: (context, state) =>
              Text('Hi, ${state.user.firstName?.capitalize! ?? 'User'}'),
        ),
      ),
      body: Container(
        color: context.theme.backgroundColor,
        padding: kPadding.copyWith(bottom: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Your Details\nor Select Additional Roles',
              style: context.textTheme.headline5,
            ),
            Gap(2.height),
            _buildSubscriptionUpdate(context),
            Gap(2.height),
            BlocBuilder<SelectRoleCubit, SelectRoleState>(
              builder: (context, state) {
                return Expanded(
                  child: MyListview(
                    isLoading: state.isLoading,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => MyListTile(
                      text: state.roles[index].role,
                      onTap: () async {
                        cubit.updateRole(state.roles[index]);
                      },
                    ),
                    data: state.roles,
                    onRetry: cubit.getRoles,
                  ),
                );
              },
            ),
            Gap(2.height),
            BlocBuilder<SelectRoleCubit, SelectRoleState>(
              builder: (context, state) {
                return Visibility(
                  child: _selectRoleButton(context),
                );
              },
            ),
            Gap(1.height),
          ],
        ),
      ),
    );
  }

  Container _selectRoleButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.w),
      // decoration: MyDecoration.bottomButtonShadow(),
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
              Get.to(
                () => SelectRolesRegistrationPage(
                  onRoleUpdated: () {
                    Get.back();
                    context.read<SelectRoleCubit>().getRoles();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionUpdate(BuildContext context) {
    final api = context.read<Api>();
    final endDate = api.getUserData()?.subscriptionEndDate;
    final date = MyDecoration.formatDate(endDate);

    return Container(
      padding: kPadding,
      decoration: MyDecoration.decoration(
        shadow: false,
        color: context.theme.primaryColor.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Subscribed',
                style: context.textTheme.headline6,
              ),
              // Gap(2.width),
              const Spacer(),
              const Icon(Icons.check_circle, color: Colors.teal),
            ],
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Subscription renew date: ',
                  style: context.textTheme.subtitle2,
                ),
                TextSpan(
                  text: date,
                  style: context.textTheme.subtitle2?.copyWith(
                    color: context.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
