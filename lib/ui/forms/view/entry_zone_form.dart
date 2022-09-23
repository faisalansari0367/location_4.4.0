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

class Form1 extends StatefulWidget {
  final ValueChanged<String>? onSubmit;

  final Forms form1;

  const Form1({Key? key, required this.form1, this.onSubmit}) : super(key: key);

  @override
  State<Form1> createState() => _Form1State();
}

class _Form1State extends State<Form1> {
  List<QuestionData> data = [];
  UserData? userData;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    userData = context.read<Api>().getUserData();
    context.read<Api>().userDataStream.listen((event) {
      if (event == null) return;
      userData = event;
    });
    data = (widget.form1.questions ?? []).map((e) => QuestionData(question: e)).toList();
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
      case 'riskRating':
        return Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: MyDropdownField(
            options: ['Low', 'Medium', 'High'],
            onChanged: (s) => item.value = s,
            hintText: 'Risk rating',
            // value: controller.text,
            value: item.value ?? '',
          ),
        );
      case 'fullName':
        // case 'nameOfWarakirriFarmVisiting':
        item.value = userData!.firstName! + ' ' + userData!.lastName!;
        return CvdTextField(
          name: item.question,
          value: userData!.firstName! + ' ' + userData!.lastName!,
          onChanged: (s) {
            setState(() {
              item.value = s;
            });
          },
        );

      case 'nameOfWarakirriFarmVisiting':
        item.value = 'BOOLAVILLA';
        return MyDropdownField(
          hintText: item.question,
          value: item.value ?? '',
          options: [
            'BOOLAVILLA',
            "COWABBIE - MUKOORA",
            'ORANGE PARK',
            ' WILLARO',
            ' MYOBIE',
            ' BAINGARRA',
            'BULLARTO DOWNS',
            ' CARINUP',
            ' LOBETHAL',
            ' MAWARRA',
            'YOONA SPRINGS',
          ],
          // name: item.question,

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

      case 'day/date/time':
        item.value = DateTime.now().toIso8601String();
        return MyDateField(
          label: item.question,
          onChanged: (s) => item.value = s,
          date: DateTime.now().toIso8601String(),
        );

      case 'company':
        return CvdTextField(
          textCapitalization: TextCapitalization.characters,
          name: item.question,
          onChanged: (s) {
            setState(() {
              item.value = s;
            });
          },
        );

      case 'mobile':
        item.value = userData?.phoneNumber;
        return PhoneTextField(
          controller: TextEditingController(text: userData?.phoneNumber),
          onChanged: (number, countryCode) {
            item.value = number;
          },
        );
      //   break;

      case 'expectedDepartureTime':
        // case 'day/date/time':
        return MyDateField(
          label: item.question,
          onChanged: (s) => item.value = s,
          date: item.value,
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
    // validate
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
