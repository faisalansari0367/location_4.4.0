import 'package:bioplus/constants/index.dart';
import 'package:bioplus/helpers/validator.dart';
import 'package:bioplus/ui/add_pic/provider/provider.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/state_dropdown_field.dart';
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
                  maxLength: 8,
                ),
                MyTextField(
                  hintText: 'ngr'.toUpperCase(),
                  textCapitalization: TextCapitalization.characters,
                  onChanged: provider.onNgrChanged,
                ),
                MyTextField(
                  hintText: 'Company Name',
                  textCapitalization: TextCapitalization.characters,
                  onChanged: provider.onCompanyChanged,
                ),
                MyTextField(
                  hintText: 'Property Name',
                  textCapitalization: TextCapitalization.characters,
                  onChanged: provider.onPropertyChanged,
                ),
                MyTextField(
                  hintText: 'Owner / Manager',
                  onChanged: provider.onOwnerChanged,
                ),
                MyTextField(
                  hintText: 'Street',
                  textCapitalization: TextCapitalization.characters,
                  onChanged: provider.onStreetChanged,
                ),
                MyTextField(
                  hintText: 'Town',
                  textCapitalization: TextCapitalization.characters,
                  onChanged: provider.onTownChanged,
                ),
                StateDropdownField(
                  onChanged: provider.onStateChanged,
                ),
                // const MyTextField(
                //   hintText: 'City',
                // ),
                MyTextField(
                  hintText: 'Post Code',
                  maxLength: 4,
                  validator: Validator.postcode,
                  onChanged: provider.onPostCodeChanged,
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
