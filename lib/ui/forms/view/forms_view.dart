import 'package:background_location/ui/forms/cubit/forms_cubit_cubit.dart';
import 'package:background_location/ui/forms/widget/qr_scan_page.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../constants/index.dart';
import '../models/form_field_data.dart';

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
    final cubit = context.read<FormsCubit>();
    // print(string);
    return Scaffold(
      appBar: MyAppBar(
        title: Text(title ?? 'Scanned form'),
        showDivider: true,
      ),
      body: PageView(
        controller: cubit.state.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _firstPage(cubit),
          Consumer<FormsCubit>(
            builder: (context, value, child) => QrScanPage(qrData: value.state.qrData),
          ),
        ],
      ),
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
                itemCount: state.state.questions.length,
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
    final item = cubit.state.questions[index];
    // final field = item.fieldWidget;
    // final fieldInCamelCase = field.camelCase;
    final fieldData = UserFormData(
      cubit,
      name: (item.question.replaceFirst(':', '')),
      controller: TextEditingController(),
      questionData: item,
    );
    return fieldData.fieldWidget;
    // return fieldData.fieldWidget;

    // if (FieldType.values.contains(fieldData.fieldType)) {
    //   if (!fieldData.fieldType.isText) return fieldData.fieldWidget;
    // // }
    // return FormCard(
    //   question: item.question,
    //   selectedValue: item.value,
    //   onChanged: (s) => cubit.onChanged(s, index),
    // );
  }
}
