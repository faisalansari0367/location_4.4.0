import 'package:bioplus/constants/index.dart';
import 'package:bioplus/helpers/validator.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:bioplus/widgets/state_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddPicForm extends StatelessWidget {
  const AddPicForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('Add Pic Form'),
      ),
      body: SingleChildScrollView(
        padding: kPadding,
        child: AutoSpacing(
          spacing: Gap(5.h),
          children: [
            // _buildField(context, 'PIC'),
            const MyTextField(
              hintText: 'Pic',
            ),
            const MyTextField(
              hintText: 'Property Name',
            ),
            StateDropdownField(
              onChanged: (value) {},
            ),
            const MyTextField(
              hintText: 'Street',
            ),
            const MyTextField(
              hintText: 'Town',
            ),
            const MyTextField(
              hintText: 'City',
            ),
            const MyTextField(
              hintText: 'Post Code',
              validator: Validator.postcode,
            ),
            CountryField(
              label: 'Country Of Residency',
              onCountryChanged: (value) {},
              // hintText: 'Country Of Residency',
            ),
            const MyTextField(
              hintText: 'Company',
            ),
            const MyTextField(
              hintText: 'Owner',
            ),
            const MyTextField(
              hintText: 'Species',
            ),
            const MyTextField(
              hintText: 'ngr',
            ),
            // SpeciesWidget(
            //   data: ,
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildField(BuildContext context, String s, {String? t}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Text(
            s.capitalize!,
            style: context.theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Gap(5.h),
        MyTextField(
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            // fontSize: 16.sp,
          ),
          // hintText: s,
          initialValue: t,
          decoration:
              MyDecoration.recangularInputDecoration(context).copyWith(),
        ),
      ],
    );
  }
}
