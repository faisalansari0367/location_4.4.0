import 'package:background_location/constants/constans.dart';
import 'package:background_location/constants/my_decoration.dart';
import 'package:background_location/constants/strings.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/ui/role_details/view/role_details_page.dart';
import 'package:background_location/ui/splash/splash_screen.dart';
import 'package:background_location/widgets/listview/my_listview.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        title: BlocBuilder<SelectRoleCubit, SelectRoleState>(
          builder: (context, state) {
            return Text('Hi, ${cubit.state.userName}');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              cubit.api.logout();
              Get.offAll(() => SplashScreen());
            },
          ),
          Gap(10.w),
        ],
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
                itemBuilder: (context, index) => _buildRole(state.roles[index], context),
                data: state.roles,
                onRetry: cubit.getRoles,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRole(String role, BuildContext context) {
    return ListTile(
      dense: false,
      selected: true,
      shape: MyDecoration.inputBorder.copyWith(
        borderRadius: kBorderRadius,
      ),
      onTap: () => Get.to(() => RoleDetailsPage(role: role)),
      selectedColor: Colors.black,
      title: Text(role),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey.shade800,
      ),
    );
  }
}
