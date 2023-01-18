import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/select_roles_registration/cubit/select_roles_registration_cubit.dart';
import 'package:bioplus/ui/select_roles_registration/view/switch_tile.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class SelectRolesRegistrationView extends StatelessWidget {
  const SelectRolesRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: Text('Select Roles')),
      body: Consumer<RolesRegistrationCubit>(
        builder: _builder,
      ),
    );
  }

  Widget _builder(
    BuildContext context,
    RolesRegistrationCubit value,
    Widget? child,
  ) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          padding: kPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // note one role is required to proceed further
              Gap(10.h),
              Container(
                // color: Colors.white,
                child: Text(
                  'Choose Service Roles',
                  style: context.textTheme.headline6,
                ),
              ),
              Gap(20.h),
              Expanded(
                child: InfiniteList(
                  isLoading: value.baseState.isLoading,
                  onFetchData: () {},
                  separatorBuilder: (context) => Gap(10.h),
                  itemBuilder: itemBuilder,
                  itemCount: value.state.rolesList.length,
                ),
              ),

              Gap(60.h),
              // Gap(20.h),
              // Gap(20.h),
              // Gap(20.h),
              // Gap(20.h),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          width: 100.width,
          child: Container(
            // LINEAR GRADIENT
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 255, 255, 255),
                  blurRadius: 15,
                  offset: Offset(10, 50),
                  spreadRadius: 60,
                ),
              ],
            ),
            child: SizedBox(
              height: 70.h,
              child: Center(
                child: MyElevatedButton(
                  width: 80.width,

                  onPressed: () async => await value.updateRole(),
                  text: Strings.continue_,
                  // text: 'Next',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final cubit = context.read<RolesRegistrationCubit>();
    final role = cubit.state.rolesList[index];
    return MySwitchTile(
      model: role,
      onTap: () => cubit.buyServiceRole(role),
    );
  }
}
