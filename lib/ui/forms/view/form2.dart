import 'dart:convert';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/cvd_form/widgets/cvd_textfield.dart';
import 'package:background_location/ui/forms/cubit/forms_cubit_cubit.dart';
import 'package:background_location/ui/forms/widget/form_card.dart';
import 'package:background_location/widgets/listview/my_listview.dart';
import 'package:background_location/widgets/signature/signature_widget.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../widgets/dialogs/dialog_service.dart';
import '../../../widgets/dialogs/error.dart';

class Form2 extends StatefulWidget {
  final ValueChanged<String>? onSubmit;

  final Forms form2;

  const Form2({Key? key, required this.form2, this.onSubmit}) : super(key: key);

  @override
  State<Form2> createState() => _Form2State();
}

class _Form2State extends State<Form2> {
  List<QuestionData> data = [];
  List<String> roles = [];
  UserData? userData;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    var api = context.read<Api>();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      api.getUserRoles().then((value) {
        value.when(
            success: (s) {
              roles = s.map((e) => e.role).toList();
              setState(() {});
              // }, failure: (f) {
              //   DialogService.showErrorDialog(f);
              // });
            },
            failure: (s) {});
        // roles = value;
        // setState(() {});
      });
      // api.userRolesStream.listen((value) {
      //   if (value != null) roles = value.map((e) => e.role).toList();
      //   setState(() {});
      // });
    });

    userData = api.getUserData();
    data = (widget.form2.questions ?? []).map((e) => QuestionData(question: e)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPadding,
      child: Column(
        children: [
          Form(
            key: formKey,
            child: MyListview(
              shrinkWrap: true,
              // padding: kPadding,
              data: data,
              itemBuilder: itemBuilder,
            ),
          ),
          Gap(20.h),
          MyElevatedButton(
            text: 'Submit',
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final item = data[index];

    switch (item.question.replaceAll(':', '').toCamelCase) {
      case 'serviceRole':
        return Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: MyDropdownField(
            options: roles,
            onChanged: (s) => item.value = s,
            hintText: item.question,
            // value: controller.text,
            value: item.value ?? '',
          ),
        );

      case 'reasonForVisit':
      case 'rego':
        return CvdTextField(
          name: item.question,
          onChanged: (s) {
            setState(() {
              item.value = s;
            });
          },
        );

      case 'signature':
        return SignatureWidget(
          signature: userData?.signature,
          onChanged: (value) => item.value = value,
        );

      default:
        return QuestionCard(
          question: item.question,
          selectedValue: item.value,
          onChanged: (s) => setState(() {
            item.value = s;
          }),

          // name: item,
        );
    }
  }

  Future<void> onPressed() async {
    // check validation
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (!_validate())
      return DialogService.showDialog(
        child: ErrorDialog(
          message: 'All fields are required',
          onTap: Get.back,
          buttonText: 'Try Again',
        ),
      );
    // final userData = api.getUserData();
    // getJsonData();
    final jsonData = data.map((e) => e.toJson()).toList();
    widget.onSubmit?.call(jsonEncode(jsonData));

    // final result = await context.read<MapsRepo>().logBookEntry(userData!.pic!, jsonEncode(jsonData), polygon.id!);
    // result.when(
    //   success: (data) {
    //     DialogService.success('Form Submitted', onCancel: () {
    //       Get.back();
    //       Get.back();
    //     });
    //     // Get.back();
    //   },
    //   failure: (e) => DialogService.failure(error: e),
    // );
  }

  bool _validate() {
    bool result = true;
    for (var item in data) {
      if ([null, ''].contains(item.value)) {
        result = false;
        break;
      }
    }
    return result;
  }
}
