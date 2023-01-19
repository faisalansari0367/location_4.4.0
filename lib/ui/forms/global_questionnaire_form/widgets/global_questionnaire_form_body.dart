import 'package:bioplus/constants/constans.dart';
import 'package:bioplus/constants/my_decoration.dart';
import 'package:bioplus/ui/forms/global_questionnaire_form/provider/provider.dart';
import 'package:bioplus/ui/forms/models/global_form_model.dart';
import 'package:bioplus/ui/forms/widget/add_list.dart';
import 'package:bioplus/ui/forms/widget/form_card.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/my_elevated_button.dart';
import 'package:bioplus/widgets/signature/signature_widget.dart';
import 'package:bioplus/widgets/text_fields/date_field.dart';
import 'package:bioplus/widgets/text_fields/my_dropdown_field.dart';
import 'package:bioplus/widgets/text_fields/my_text_field.dart';
import 'package:bioplus/widgets/text_fields/text_formatters/input_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

/// {@template global_questionnaire_form_body}
/// Body of the GlobalQuestionnaireFormPage.
///
/// Add what it does
/// {@endtemplate}
class GlobalQuestionnaireFormBody extends StatelessWidget {
  /// {@macro global_questionnaire_form_body}
  const GlobalQuestionnaireFormBody({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      return Consumer<GlobalQuestionnaireFormNotifier>(
        builder: (context, state, child) {
          return Form(
            key: state.formKey,
            child: SingleChildScrollView(
              controller: state.sc,
              padding: kPadding,
              child: AutoSpacing(
                children: [
                  _addList(state, state.model.arePeopleTravelingWith),
                  _card(state, state.model.isQfeverVaccinated),
                  _card(state, state.model.isFluSymptoms, onChanged: (value) {
                    if (value) {
                      DialogService.error('Consider the safety of others before you enter this zone.');
                    }
                    state.onChanged(state.model.isFluSymptoms, value);
                  },),
                  _card(
                    state,
                    state.model.isOverSeaVisit,
                    onChanged: (s) {
                      if (s) {
                        DialogService.error('Make sure you contact the owner before entering the Property.');
                      }
                      state.onChanged(state.model.isOverSeaVisit, s);
                    },
                  ),
                  _card(state, state.model.isAllMeasureTaken),
                  _card(state, state.model.isOwnerNotified),
                  MyTextField(
                    hintText: state.model.rego.question,
                    inputFormatters: [CapitalizeAllInputFormatter()],
                    // onChanged: (value) {
                    //   state.model.rego.value = value;
                    // },
                    onChanged: (value) {
                      state.onChanged(state.model.rego, value);
                    },
                  ),
                  MyDropdownField(
                    onChanged: (s) {
                      // model.riskRating.value = s;
                      state.onChanged(state.model.riskRating, s);
                    },
                    hintText: state.model.riskRating.question,
                    value: state.model.riskRating.value,
                    options: ['Low', 'Medium', 'High'].map((e) => e.toUpperCase()).toList(),
                  ),
                  GestureDetector(
                    onTap: () => state.pickDateTime(state.model.expectedDepartureDate, context),
                    child: AbsorbPointer(
                      child: MyDateField(
                        label: state.model.expectedDepartureDate.question,
                        date: state.model.expectedDepartureDate.value,
                        showTime: true,
                        // onChanged: (s) {
                        //   state.pickDateTime(state.model.expectedDepartureDate, context);
                        // },
                      ),
                    ),
                  ),
                  // MyTimeField(
                  //   label: state.model.expectedDepartureTime.question,
                  //   date: state.model.expectedDepartureTime.value,
                  //   onChanged: (s) {
                  //     state.onChanged(state.model.expectedDepartureTime, s);
                  //   },
                  // ),
                  SignatureWidget(
                    signature: state.model.signature.value,
                    onChanged: (s) async {
                      state.onChanged(state.model.signature, s);
                      await 500.milliseconds.delay();
                      state.scrollToEnd();
                    },
                  ),
                  Container(
                    decoration: MyDecoration.decoration(),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: CheckboxListTile(
                      title: const Text(
                          'I declare that any animals/products I am transporting are accompanied by correct movement documentation.',),
                      value: state.selfDeclaration,
                      onChanged: (s) {
                        state.onChangeDecalration(s ?? false);
                      },
                    ),
                  ),
                  MyElevatedButton(
                    text: 'Submit',
                    onPressed: () async => state.submit(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },);
  }

  Widget _card(GlobalQuestionnaireFormNotifier state, QuestionData data, {ValueChanged<bool>? onChanged}) {
    return Container(
      decoration: MyDecoration.decoration(),
      child: QuestionCard(
        question: data.question,
        selectedValue: data.value,
        onChanged: onChanged ?? (s) => state.onChanged(data, s),
      ),
    );
  }

  Widget _addList(GlobalQuestionnaireFormNotifier state, QuestionData data) {
    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: 375.milliseconds,
      curve: Curves.easeInOut,
      child: Container(
        decoration: MyDecoration.decoration(),
        // padding: EdgeInsets.only(bottom: 10.h),
        child: Column(
          children: [
            QuestionCard(
              question: data.question,
              selectedValue: data.value,
              onChanged: (value) async => state.onChanged(data, value),
            ),
            if (data.value ?? false) ...[
              Gap(10.h),
              AddList(onChanged: state.onChangePeopleList),
            ]
          ],
        ),
      ),
    );
  }
}
