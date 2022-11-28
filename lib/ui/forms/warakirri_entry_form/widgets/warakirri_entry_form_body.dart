import 'package:background_location/ui/forms/warakirri_entry_form/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/index.dart';
import '../../../../widgets/auto_spacing.dart';
import '../../../../widgets/dialogs/dialog_service.dart';
import '../../models/global_form_model.dart';
import '../../widget/add_list.dart';
import '../../widget/form_card.dart';

/// {@template warakirri_entry_form_body}
/// Body of the WarakirriEntryFormPage.
///
/// Add what it does
/// {@endtemplate}
class WarakirriEntryFormBody extends StatelessWidget {
  /// {@macro warakirri_entry_form_body}
  const WarakirriEntryFormBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WarakirriEntryFormNotifier>(
      builder: (context, state, child) {
        return Form(
          key: state.formKey,
          child: SingleChildScrollView(
            padding: kPadding,
            child: AutoSpacing(
              children: [
                _buildHeading(context),
                _addList(state, state.model.arePeopleTravelingWith),
                _card(
                  state,
                  state.model.isFluSymptoms,
                  onChanged: (value) {
                    if (value) {
                      DialogService.error(
                        'Do not enter the farm, for the health and wellbeing of all Aurora team members',
                      );
                    }
                    state.onChanged(state.model.isFluSymptoms, value);
                  },
                ),
                _card(
                  state,
                  state.model.isOverSeaVisit,
                  onChanged: (s) {
                    if (s) {
                      DialogService.error(
                        'Do not enter the farm. Call the farm manager for directions.',
                      );
                    }
                    state.onChanged(state.model.isOverSeaVisit, s);
                  },
                ),
                _card(state, state.model.isInducted),
                _card(state, state.model.isConfinedSpace),
                _dateField(state, context),
                _buildZoneName(state),
                _buildTextField('Full Name', state.userData?.fullName),
                _buildTextField(
                    'Phone Number', (state.userData?.countryCode ?? '') + '' + (state.userData?.phoneNumber ?? '')),
                _buildTextField('Company Name', state.userData?.company),
                _additionalInfo(context, state),
                _buildSignOff(context),
                _buildPoints(state),
                _selfDeclaration(state),
                MyElevatedButton(
                  text: 'Submit',
                  isLoading: false,
                  onPressed: () async => await state.submit(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Text _buildHeading(BuildContext context) {
    return Text(
      'All visitors and contract workers on farm must complete this check in form.',
      style: context.textTheme.headline6?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
  }

  GestureDetector _dateField(WarakirriEntryFormNotifier state, BuildContext context) {
    return GestureDetector(
      onTap: () => state.pickDateTime(state.model.expectedDepartureDate, context),
      child: AbsorbPointer(
        absorbing: true,
        child: MyDateField(
          label: state.model.expectedDepartureDate.question,
          date: state.model.expectedDepartureDate.value,
          showTime: true,
          onChanged: (s) {
            state.pickDateTime(state.model.expectedDepartureDate, context);
          },
        ),
      ),
    );
  }

  Widget _buildZoneName(WarakirriEntryFormNotifier state) {
    return MyTextField(
      enabled: false,
      hintText: state.model.warakirriFarm.question,
      initialValue: state.model.warakirriFarm.value ?? state.warakirriFarms.last,
    );
  }

  Widget _buildTextField(String label, String? value) {
    return MyTextField(
      hintText: label,
      // initialValue: '${state.userData?.countryCode ?? ''} ${state.userData?.phoneNumber ?? ''}',
      initialValue: value,
      // controller: TextEditingController(text: value),
      enabled: false,
    );
  }

  TextFormField _additionalInfo(BuildContext context, WarakirriEntryFormNotifier state) {
    return TextFormField(
      minLines: 3,
      maxLines: 5,
      decoration: MyDecoration.recangularInputDecoration(context).copyWith(
        labelText: state.model.additionalInfo.question,
      ),
      onChanged: (value) => state.onChanged(state.model.additionalInfo, value),
    );
  }

  Text _buildSignOff(BuildContext context) {
    return Text(
      'Sign Off:',
      style: context.textTheme.headline6?.copyWith(
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
    );
  }

  CheckboxListTile _selfDeclaration(WarakirriEntryFormNotifier state) {
    return CheckboxListTile(
      title: Text(
        'I understand and commit to the above',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      value: state.selfDeclaration,
      onChanged: state.onChangeDecalration,
    );
  }

  Column _buildPoints(WarakirriEntryFormNotifier state) {
    return Column(
      children: state.decalations
          .map(
            (e) => Container(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDot(),
                  Gap(10.w),
                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Container _buildDot() {
    return Container(
      height: 7,
      width: 7,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
    );
  }

  Widget _card(WarakirriEntryFormNotifier state, QuestionData data, {ValueChanged<bool>? onChanged}) {
    return Container(
      child: QuestionCard(
        question: data.question,
        selectedValue: data.value,
        onChanged: onChanged ?? (s) => state.onChanged(data, s),
      ),
    );
  }

  Widget _addList(WarakirriEntryFormNotifier state, QuestionData data) {
    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: 375.milliseconds,
      curve: Curves.easeInOut,
      child: Container(
        // decoration: MyDecoration.decoration(),
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
