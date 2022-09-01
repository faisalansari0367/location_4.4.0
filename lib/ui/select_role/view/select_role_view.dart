import 'package:background_location/constants/constans.dart';
import 'package:background_location/constants/strings.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/widgets/listview/my_listview.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/my_listTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// import 'package:get/get.dart';

import '../cubit/select_role_cubit.dart';

class SelectRoleView extends StatelessWidget {
  const SelectRoleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SelectRoleCubit>();

    return Scaffold(
      appBar: MyAppBar(
        // elevation: 2,
        showBackButton: false,
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
      body: ListView(
        padding: kPadding,
        children: [
          // Gap(10.height),
          Text(
            Strings.selectYourRole,
            style: context.textTheme.headline5,
          ),
          Gap(2.height),
          BlocBuilder<SelectRoleCubit, SelectRoleState>(
            builder: (context, state) {
              return MyListview(
                isLoading: state.isLoading,
                shrinkWrap: true,
                itemBuilder: (context, index) => MyListTile(
                  text: state.roles[index],
                  onTap: () async => cubit.updateRole(
                    state.roles[index],
                  ),
                ),
                data: state.roles,
                onRetry: cubit.getRoles,
              );
            },
          ),
        ],
      ),
    );
  }
}
