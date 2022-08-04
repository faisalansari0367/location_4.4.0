import 'package:background_location/constants/strings.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/ui/maps/cubit/view/maps_page.dart';
import 'package:background_location/ui/role_details/cubit/role_details_cubit.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../widgets/my_appbar.dart';

class RoleDetailsView extends StatelessWidget {
  const RoleDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RoleDetailsCubit>();
    final gap = Gap(0.5.height);
    return Scaffold(
      appBar: MyAppBar(
        title: Text(
          cubit.role,
          // style: const TextStyle(color: Colors.black),
        ),
        // backgroundColor: context.theme.scaffoldBackgroundColor,s
      ),
      body: Padding(
        padding: EdgeInsets.all(20.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.yourDetails,
                style: context.textTheme.headline5,
              ),
              Gap(5.height),
              MyTextField(
                hintText: Strings.firstName,
              ),
              gap,
              MyTextField(
                hintText: Strings.lastName,
              ),
              gap,
              const EmailField(),
              gap,
              const MyTextField(
                hintText: Strings.mobile,
              ),
              gap,
              const MyTextField(
                hintText: Strings.pic,
              ),
              gap,
              MyTextField(
                hintText: Strings.properyName,
              ),
              gap,
              MyTextField(
                hintText: Strings.propertyAddress,
              ),
              gap,
              MyElevatedButton(
                onPressed: () async => Get.to(() => const MapsPage()),
                text: ('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
