import 'dart:convert';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/cvd_form/widgets/cvd_textfield.dart';
import 'package:background_location/ui/forms/cubit/forms_cubit_cubit.dart';
import 'package:background_location/ui/forms/widget/form_card.dart';
import 'package:background_location/widgets/signature/signature_widget.dart';
import 'package:background_location/widgets/text_fields/time_field.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../widgets/dialogs/dialog_service.dart';
import '../../../widgets/dialogs/error.dart';

class Form1 extends StatefulWidget {
  final bool isAurora;
  final ValueChanged<String>? onSubmit;

  final Forms form1;

  const Form1({
    Key? key,
    required this.form1,
    this.onSubmit,
    this.isAurora = false,
  }) : super(key: key);

  @override
  State<Form1> createState() => _Form1State();
}

class _Form1State extends State<Form1> {
  List<QuestionData> data = [];
  UserData? userData;
  final formKey = GlobalKey<FormState>();
  final riskRating = QuestionData(question: 'Risk Rating');
  final expectedDepartureTime = QuestionData(question: 'Expectated Departure Time');
  final fullName = QuestionData(question: 'Full Name');
  final company = QuestionData(question: 'Company');
  final mobile = QuestionData(question: 'Mobile');
  final warraKirriFarm = QuestionData(question: 'Name of Warakirri farm visiting');
  final auroraDairy = QuestionData(question: 'Name of Aurora Dairy farm visiting');
  final date = QuestionData(question: 'Date');
  final time = QuestionData(question: 'Time');
  final signature = QuestionData(question: 'Signature');

  @override
  void initState() {
    userData = context.read<Api>().getUserData();
    mobile.value = userData?.phoneNumber;
    fullName.value = '${userData!.firstName!} ${userData!.lastName!}';
    date.value = DateTime.now().toIso8601String();
    time.value = DateTime.now().toIso8601String();
    company.value = userData?.company;
    context.read<Api>().userDataStream.listen((event) {
      if (event == null) return;
      userData = event;
    });

    data = form1Data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: kPadding,
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  ...data.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: QuestionCard(
                        question: item.question,
                        selectedValue: item.value,
                        onChanged: (s) => setState(() {
                          item.value = s;
                        }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: MyDropdownField(
                      options: const ['Low', 'Medium', 'High'],
                      onChanged: (s) => riskRating.value = s,
                      hintText: 'Risk rating',
                      value: riskRating.value ?? '',
                    ),
                  ),
                  Gap(15.h),
                  MyTimeField(
                    label: expectedDepartureTime.question,
                    onChanged: (s) => setState(() {
                      expectedDepartureTime.value = s;
                    }),
                    date: expectedDepartureTime.value,
                  ),
                  Gap(15.h),
                  CvdTextField(
                    name: fullName.question,
                    value: fullName.value,
                    onChanged: (s) {
                      setState(() {
                        fullName.value = s;
                      });
                    },
                  ),
                  Gap(15.h),
                  CvdTextField(
                    textCapitalization: TextCapitalization.characters,
                    name: company.question,
                    value: company.value,
                    onChanged: (s) {
                      setState(() {
                        company.value = s;
                      });
                    },
                  ),
                  Gap(15.h),
                  PhoneTextField(
                    controller: TextEditingController(text: mobile.value),
                    onChanged: (number, countryCode) {
                      mobile.value = number;
                    },
                  ),
                  Gap(15.h),
                  MyDropdownField(
                    hintText: widget.isAurora ? auroraDairy.question : warraKirriFarm.question,
                    value: widget.isAurora ? auroraDairy.value ?? '' : warraKirriFarm.value ?? '',
                    options: widget.isAurora ? _auroraDairies : _warrakirriFarmOptions,
                    onChanged: (s) {
                      setState(() {
                        if (widget.isAurora) {
                          auroraDairy.value = s;
                        } else {
                          warraKirriFarm.value = s;
                        }
                      });
                    },
                  ),
                  Gap(15.h),
                  MyDateField(
                    label: date.question,
                    date: DateTime.now().toIso8601String(),
                    onChanged: (s) => setState(
                      () => date.value = s,
                    ),
                  ),
                  Gap(15.h),
                  MyTimeField(
                    label: time.question,
                    date: DateTime.now().toIso8601String(),
                    onChanged: (s) => setState(() => time.value = s),
                  ),
                  Gap(15.h),
                  SignatureWidget(
                    signature: userData?.signature,
                    onChanged: (s) {
                      setState(() => signature.value = s);
                    },
                  ),
                ],
              ),
            ),
            Gap(20.h),
            MyElevatedButton(
              text: 'Submit',
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }

  List<QuestionData> form1Data() {
    final questions = [
      {
        'field':
            'Do you have any of the following symptoms: feeling unwell or displaying flu-like symptoms, sudden loss of smell or taste, fever, cough, sore throat, fatigue or shortness of breath?',
        'value': null,
      },
      {
        'field': 'Have you been overseas in the past 7 days?',
        'value': null,
      },
      {
        'field': 'Have you been overseas in the past 7 days?',
        'value': null,
      },
      {
        'field':
            'Does the work being undertaken involve exposure to Confined Spaces, Native Vegetation Clearing, Work at Heights or Firearm use? Are you working on any plant that needs to be isolated?',
        'value': null,
      }
    ];
    return questions.map((e) => QuestionData(question: e['field']!)).toList();
  }

  List<String> get _warrakirriFarmOptions {
    return [
      'BOOLAVILLA',
      'COWABBIE - MUKOORA',
      'ORANGE PARK',
      ' WILLARO',
      ' MYOBIE',
      ' BAINGARRA',
      'BULLARTO DOWNS',
      ' CARINUP',
      ' LOBETHAL',
      ' MAWARRA',
      'YOONA SPRINGS',
    ];
  }

  List<String> get _auroraDairies {
    return [
      'Ashwood',
      'BAINGARRA',
      'Ballyduggen',
      'Bangalay',
      'Barnett',
      'Benedicts',
      'Bonney View',
      'BOOLAVILLA',
      'BULLARTO DOWNS',
      'CANNUP',
      'Canunda Park',
      'Charlecoate',
      'Coradjil Place',
      'COWABBIE - MULOORA',
      'Field',
      'Finch',
      'Glenfarm',
      'Harris Road',
      'Hillview',
      'Hughes',
      'Kingsley Estate',
      'Kurleah',
      'Landour',
      'LOBETHAL',
      'Maritana',
      'MAWARRA',
      'McAinch',
      'Mirembeek',
      'Missens',
      'MYOBIE',
      'ORANGE PARK',
      'Orford Wells',
      'Papic',
      'Patrick’s Day',
      'Peneplain',
      'Poorinda',
      'Port Mac Bottom Dairy',
      'Port Mac Top Dairy',
      'Riverview',
      'Roys',
      'Scotts',
      'Segafredo',
      'Slatterys Road',
      'Tarqua',
      'Tarraville',
      'Warwillah',
      'Welbourne',
      'Wheelers',
      'WILLARO',
      'YOONA SPRINGS',
    ];
  }

  void updateDateAndTime(QuestionData questionData, s) {
    if (questionData.value == null) {
      return;
    }
    final value = TimeOfDay.fromDateTime(DateTime.parse(s));
    final date = DateTime.parse(questionData.value!);
    final newDate = DateTime(date.year, date.month, date.day, value.hour, value.minute);
    questionData.value = newDate.toIso8601String();
    setState(() {});
  }

  Future<void> onPressed() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (!_validate()) {
      return DialogService.showDialog(
        child: ErrorDialog(
          message: 'All fields are required',
          onTap: Get.back,
          buttonText: 'Try Again',
        ),
      );
    }

    final datalist = [
      ...data,
      riskRating,
      expectedDepartureTime,
      fullName,
      company,
      mobile,
      if (!widget.isAurora) warraKirriFarm else auroraDairy,
      date,
      time,
      signature
    ];

    final jsonData = datalist.map((e) => e.toJson()).toList();
    widget.onSubmit?.call(jsonEncode(jsonData));
  }

  bool _validate() {
    var result = true;
    for (final item in data) {
      if ([null, ''].contains(item.value)) {
        result = false;
        break;
      }
    }
    return result;
  }
}
