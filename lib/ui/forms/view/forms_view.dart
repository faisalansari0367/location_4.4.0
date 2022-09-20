import 'package:background_location/ui/cvd_form/widgets/cvd_textfield.dart';
import 'package:background_location/ui/forms/cubit/forms_cubit_cubit.dart';
import 'package:background_location/ui/forms/view/entry_zone_form.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../constants/index.dart';

class FormsView extends StatelessWidget {
  // final Map<String, dynamic> formData;
  final String? title;
  const FormsView({
    Key? key,
    this.title,
    // required this.formData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final cubit = context.read<FormsCubit>();
    // print(string);
    return Scaffold(
      appBar: MyAppBar(
        title: Text(title ?? 'Scanned form'),
        showDivider: true,
      ),
      body: Consumer<FormsCubit>(builder: (context, cubit, child) {
        if (cubit.state.isLoading) return CircularProgressIndicator();
        return PageView(
          controller: cubit.state.pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Form1(form1: cubit.forms.first),
            // Consumer<FormsCubit>(
            //   builder: (context, value, child) => QrScanPage(qrData: value.state.qrData),
            // ),
          ],
        );
      }),
    );
  }

  SingleChildScrollView _secondPage(FormsCubit cubit) {
    return SingleChildScrollView(
      padding: kPadding,
      child: Form(
        key: cubit.formKey,
        child: Column(
          children: [
            Consumer<FormsCubit>(
              builder: (context, state, child) {
                return ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Gap(15.h),
                  itemCount: state.state.questions.length,
                  itemBuilder: itemBuilder,
                  // padding: kPadding,
                );
              },
            ),
            // Gap(10.h),
            MyElevatedButton(
              text: 'Submit',
              onPressed: () async => cubit.onPressed(),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView _firstPage(FormsCubit cubit) {
    return SingleChildScrollView(
      padding: kPadding,
      child: Column(
        children: [
          Consumer<FormsCubit>(
            builder: (context, state, child) {
              return ListView.separated(
                primary: false,
                shrinkWrap: true,
                separatorBuilder: (context, index) => Gap(15.h),
                itemCount: state.forms.isEmpty ? 0 : state.forms.first.questions?.length ?? 0,
                itemBuilder: itemBuilder,
                // padding: kPadding,
              );
            },
          ),
          Gap(15.h),
          MyElevatedButton(
            text: 'Submit',
            onPressed: () async => cubit.onPressed(),
          ),
        ],
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final cubit = context.read<FormsCubit>();
    final item = cubit.forms[0].questions![index];

    switch (item) {
      // case :

      //   break;
      default:
        return CvdTextField(
          name: item,
        );
    }
  }
}
