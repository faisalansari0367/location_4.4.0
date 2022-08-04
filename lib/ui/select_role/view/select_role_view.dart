import 'package:background_location/constants/constans.dart';
import 'package:background_location/constants/my_decoration.dart';
import 'package:background_location/constants/strings.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/ui/role_details/view/role_details_page.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../cubit/select_role_cubit.dart';

class SelectRoleView extends StatelessWidget {
  const SelectRoleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SelectRoleCubit>();

    return Scaffold(
      appBar: MyAppBar(),
      body: ListView(
        padding: kPadding,
        children: [
          // Gap(10.height),
          Text(
            Strings.iAmA,
            style: context.textTheme.headline5,
          ),
          Gap(2.height),
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = cubit.roles[index];
              return _buildRole(item, context);
            },
            separatorBuilder: (context, index) => Gap(2.height),
            itemCount: cubit.roles.length,
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
