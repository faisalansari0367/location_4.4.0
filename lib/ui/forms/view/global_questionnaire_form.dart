import 'dart:convert';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/forms/cubit/forms_cubit_cubit.dart';
import 'package:background_location/ui/forms/widget/add_list.dart';
import 'package:background_location/ui/forms/widget/form_card.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/dialogs/no_signature_found.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/signature/signature_widget.dart';
import 'package:background_location/widgets/text_fields/text_formatters/input_formatters.dart';
import 'package:background_location/widgets/text_fields/time_field.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../widgets/dialogs/dialog_service.dart';
import '../models/global_questionnaire_form_model.dart';

class GlobalQuestionnaireForm extends StatefulWidget {
  final String zoneId;
  final int? logrecordId;
  const GlobalQuestionnaireForm({Key? key, required this.zoneId, this.logrecordId}) : super(key: key);

  @override
  State<GlobalQuestionnaireForm> createState() => _GlobalQuestionnaireFormState();
}

class _GlobalQuestionnaireFormState extends State<GlobalQuestionnaireForm> {
  final model = GlobalQuestionnaireFormModel();

  List<String> names = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(context.read<Api>().getUserData()?.toJson());

    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: MyAppBar(
          title: Text(Strings.declaration),
          elevation: 3.0,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: kPadding,
            child: AutoSpacing(
              children: [
                _card(model.q1),
                // _card(model.q2),
                Container(
                  decoration: MyDecoration.decoration(),
                  child: QuestionCard(
                    question: model.q2.question,
                    selectedValue: model.q2.value,
                    onChanged: (s) {
                      if (s.toLowerCase() == 'no') {
                        DialogService.error('Consider the safety of others before you enter this zone.');
                      }
                      onChanged(model.q2, s);
                    },
                  ),
                ),
                _card(model.q3),
                // _card(model.q4),
                Container(
                  decoration: MyDecoration.decoration(),
                  child: QuestionCard(
                    question: model.q4.question,
                    selectedValue: model.q4.value,
                    onChanged: (s) {
                      if (s.toLowerCase() == 'yes') {
                        DialogService.error('Make sure you contact the owner before entering the Property.');
                      }
                      onChanged(model.q4, s);
                    },
                  ),
                ),
                // _card(model.q5),
                _addList(model.q5),
                MyTextField(
                  hintText: model.q6.question,
                  // textCapitalization: TextCapitalization.characters,
                  inputFormatters: [CapitalizeAllInputFormatter()],
                  onChanged: (value) {
                    model.q6.value = value;
                    setState(() {});
                  },
                ),
                MyDropdownField(
                  onChanged: (s) {
                    model.riskRating.value = s;
                    setState(() {});
                  },
                  hintText: model.riskRating.question,
                  value: model.riskRating.value,
                  options: ['Low', 'Medium', 'High'],
                ),
                MyDateField(
                  label: model.expectedDepartureDate.question,
                  date: model.expectedDepartureDate.value,
                  onChanged: (s) {
                    model.expectedDepartureDate.value = s;
                    setState(() {});
                  },
                ),
                MyTimeField(
                  label: model.expectedDepartureTime.question,
                  date: model.expectedDepartureTime.value,
                  onChanged: (s) {
                    model.expectedDepartureTime.value = s;
                    setState(() {});
                  },
                ),
                SignatureWidget(
                  signature: context.read<Api>().getUserData()?.signature,
                  onChanged: (s) {
                    model.signature.value = s;
                    setState(() {});
                  },
                ),

                Container(
                  decoration: MyDecoration.decoration(),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: CheckboxListTile(
                    title: Text(model.selfDeclaration.question),
                    value: model.selfDeclaration.value ?? false,
                    onChanged: (s) {
                      setState(() {
                        model.selfDeclaration.value = s;
                      });
                    },
                  ),
                ),
                MyElevatedButton(
                  text: 'Submit',
                  isLoading: false,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    if (model.signature.value == null) {
                      // DialogService.error('Please sign the declaration');
                      DialogService.showDialog(
                        child: NoSignatureFound(
                          message: 'Please sign the declaration',
                          buttonText: 'OK',
                          onCancel: Get.back,
                        ),
                      );
                      return;
                    }
                    final data = model.toJson();
                    if (data.where((e) => e['value'] == null).isNotEmpty) {
                      DialogService.error('Please fill all the fields');
                      return;
                    }
                    if (model.selfDeclaration.value == false || model.selfDeclaration.value == null) {
                      DialogService.error('Please accept the self declaration');
                      return;
                    } else if (model.q5.value == true && names.isEmpty) {
                      DialogService.error('Please add the visitors name');
                      return;
                    } else if (model.q5.value == 'yes') {
                      model.q5.value = names;
                    }

                    await submitFormData(jsonEncode(model.toJson()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _addList(QuestionData data) {
    return AnimatedSize(
      duration: 500.milliseconds,
      curve: Curves.easeInOut,
      child: Container(
        decoration: MyDecoration.decoration(),
        // padding: EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            Container(
              // decoration: MyDecoration.decoration(),
              child: QuestionCard(
                question: data.question,
                selectedValue: data.value is List<String> ? 'yes' : data.value,
                onChanged: (s) async {
                  if (s.toLowerCase() == 'yes') {
                  } else {
                    names = [];
                    setState(() {});
                  }
                  data.value = s;
                  setState(() {});
                },
              ),
            ),
            if (data.value == 'yes') ...[
              Gap(10.h),
              AddList(
                onChanged: (value) => names = value,
              ),
            ]
          ],
        ),
      ),
    );
  }

  Future<void> submitFormData(String json) async {
    final result = await context.read<Api>().udpateForm(
          widget.zoneId.toString(),
          json,
          logId: widget.logrecordId,
        );
    result.when(
      success: (data) {
        DialogService.success(
          'Form Submitted',
          onCancel: () {
            Get.back();
            Get.back();
          },
        );
      },
      failure: (e) => DialogService.failure(error: e),
    );
  }

  Widget _card(QuestionData data) {
    return Container(
      decoration: MyDecoration.decoration(),
      child: QuestionCard(
        question: data.question,
        selectedValue: data.value,
        onChanged: (s) => onChanged(data, s),
      ),
    );
  }

  void onChanged(QuestionData data, String value) {
    setState(() {
      data.value = value;
    });
  }
}
