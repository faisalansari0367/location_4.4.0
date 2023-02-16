import 'package:bioplus/constants/index.dart';
import 'package:bioplus/helpers/validator.dart';
import 'package:bioplus/ui/add_pic/provider/provider.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/state_dropdown_field.dart';
import 'package:bioplus/widgets/text_fields/text_formatters/input_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// {@template add_pic_body}
/// Body of the AddPicPage.
///
/// Add what it does
/// {@endtemplate}
class AddPicBody extends StatelessWidget {
  /// {@macro add_pic_body}
  const AddPicBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddPicNotifier>(
      builder: (context, provider, child) {
        return Form(
          key: provider.formKey,
          child: SingleChildScrollView(
            padding: kPadding,
            child: AutoSpacing(
              spacing: Gap(10.h),
              children: [
                MyTextField(
                  hintText: 'Pic'.toUpperCase(),
                  validator: Validator.pic,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: provider.onPicChanged,
                  initialValue: provider.model?.pic,
                  maxLength: 8,
                ),
                MyTextField(
                  hintText: 'ngr'.toUpperCase(),
                  validator: Validator.none,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: provider.onNgrChanged,
                  initialValue: provider.model?.ngr,
                ),
                MyTextField(
                  hintText: 'Company Name',
                  textCapitalization: TextCapitalization.characters,
                  onChanged: provider.onCompanyChanged,
                  initialValue: provider.model?.company,
                ),
                MyTextField(
                  hintText: 'Property Name',
                  textCapitalization: TextCapitalization.characters,
                  onChanged: provider.onPropertyChanged,
                  initialValue: provider.model?.propertyName,
                ),
                // MyTextField(
                //   hintText: 'Owner / Manager',
                //   onChanged: provider.onOwnerChanged,
                //   initialValue: provider.model?.owner,
                // ),
                MyTextField(
                  hintText: Strings.street,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: provider.onStreetChanged,
                  initialValue: provider.model?.street,
                ),
                MyTextField(
                  hintText: Strings.town,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: provider.onTownChanged,
                  initialValue: provider.model?.town,
                ),
                StateDropdownField(
                  onChanged: provider.onStateChanged,
                  value: provider.model?.state,
                ),
                MyTextField(
                  hintText: Strings.postCode,
                  maxLength: 4,
                  validator: Validator.postcode,
                  onChanged: provider.onPostCodeChanged,
                  initialValue: provider.model?.postcode == null
                      ? null
                      : provider.model?.postcode.toString(),
                ),
                MyTextField(
                  hintText: 'LPA Username',
                  inputFormatters: [LpaUsernameTextFormatter()],
                  controller: provider.lpaUsernameController,
                  // initialValue: provider.model?.lpaUsername,
                  // readOnly: true,
                  validator: provider.lpaUsernameController.text.isEmpty
                      ? Validator.none
                      : Validator.lpaUsername,
                  // onChanged: provider.onLPAusernameChanged,
                  // controller: provider.lpaUsernameController,
                ),
                PasswordField(
                  hintText: 'LPA Password',
                  initialValue: provider.model?.lpaPassword,
                  validator: provider.state.lpaPassword == null
                      ? Validator.none
                      : Validator.password,
                  onChanged: provider.onLpaPasswordChanged,
                ),
                MyTextField(
                  hintText: 'NLIS Username',
                  validator: Validator.none,
                  initialValue: provider.model?.nlisUsername,
                  onChanged: provider.onPostCodeChanged,
                ),
                PasswordField(
                  hintText: 'NLIS Password',
                  validator: Validator.none,
                  initialValue: provider.model?.nlisPassword,
                  onChanged: provider.onNlisPasswordChanged,
                ),
                MyTextField(
                  hintText: 'MSA Number',
                  validator: Validator.none,
                  initialValue: provider.model?.msaNumber,
                  onChanged: provider.onMsaNumberChanged,
                ),
                MyTextField(
                  hintText: 'NFAS Accreditaion Number',
                  validator: Validator.none,
                  initialValue: provider.model?.nfasAccreditationNumber,
                  onChanged: provider.onNFasAccreditationNumberChanged,
                ),
                MyElevatedButton(
                  text: 'Submit',
                  onPressed: provider.submit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
