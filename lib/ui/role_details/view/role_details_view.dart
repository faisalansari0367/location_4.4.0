import 'package:background_location/constants/constans.dart';
import 'package:background_location/constants/strings.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/ui/role_details/cubit/role_details_cubit.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/my_cross_fade.dart';
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
    final gap = Gap(1.height);
    return Scaffold(
      appBar: MyAppBar(title: Text(cubit.role)),
      body: SingleChildScrollView(
        padding: kPadding,
        child: BlocBuilder<RoleDetailsCubit, RoleDetailsState>(
          builder: (context, state) {
            return Form(
              key: cubit.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.yourDetails,
                    style: context.textTheme.headline5,
                  ),
                  Gap(3.height),
                  MyCrossFade(
                    isLoading: state.isLoading,
                    child: AutoSpacing(
                      spacing: SizedBox.shrink(),
                      children: state.fieldsData.map(
                        (item) {
                          return Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: item.fieldWidget,
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  gap,
                  gap,
                  if (!state.isLoading && state.fields.isNotEmpty)
                    MyElevatedButton(
                      onPressed: cubit.onSubmit,
                      text: ('Submit'),
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Padding _body(BuildContext context, Gap gap) {
  //   return Padding(
  //     padding: EdgeInsets.all(20.sp),
  //     child: SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             Strings.yourDetails,
  //             style: context.textTheme.headline5,
  //           ),
  //           Gap(5.height),
  //           MyTextField(
  //             hintText: Strings.firstName,
  //           ),
  //           gap,
  //           MyTextField(
  //             hintText: Strings.lastName,
  //           ),
  //           gap,
  //           const EmailField(),
  //           gap,
  //           const MyTextField(
  //             hintText: Strings.mobile,
  //           ),
  //           gap,
  //           const MyTextField(
  //             hintText: Strings.pic,
  //           ),
  //           gap,
  //           MyTextField(
  //             hintText: Strings.properyName,
  //           ),
  //           gap,
  //           MyTextField(
  //             hintText: Strings.propertyAddress,
  //           ),
  //           gap,
  //           MyElevatedButton(
  //             onPressed: () async => Get.to(() => const MapsPage()),
  //             text: ('Submit'),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
