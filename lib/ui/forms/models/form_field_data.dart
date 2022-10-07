// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:background_location/constants/index.dart';
import 'package:background_location/models/field_data.dart';
import 'package:background_location/ui/forms/cubit/forms_cubit_cubit.dart';
import 'package:background_location/ui/forms/widget/form_card.dart';
import 'package:background_location/ui/role_details/models/field_types.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserFormData extends FormFieldData {
  final QuestionData questionData;
  // final Map<String, dynamic>? data;
  final FormsCubit cubit;
  UserFormData(
    this.cubit, {
    required String name,
    required TextEditingController controller,
    required this.questionData,
  }) : super(name: name, controller: controller);

  @override
  Widget get fieldWidget {
    switch (name.toCamelCase) {
      case 'serviceRole':
        return MyDropdownField(
          options: data['roles'],
          onChanged: (s) => controller.text = s!,
          hintText: 'Select Role',
          value: controller.text,
        );
      case 'reasonForVisit':
        return MyTextField(
          // options: cubit.state.roles,
          // onChanged: (s) => controller.text = s!,
          hintText: 'Reason For Visit',
          controller: controller,
          // minLine: 10,
          maxLines: 2,

          // maxLength: 10,
        );
      case 'riskRating':
        return Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: MyDropdownField(
            options: const ['Low', 'Medium', 'High'],
            onChanged: (s) => controller.text = s!,
            hintText: 'Risk rating',
            value: controller.text,
          ),
        );
      case 'expectedDepartureTime':
      case 'day/date/time':
        return MyDateField(
          label: name,
          onChanged: (s) => controller.text = s,
          date: controller.text,
        );
      case 'fullName':
      case 'nameOfWarakirriFarmVisiting':
        return MyTextField(
          hintText: name,
          onChanged: (s) => controller.text = s,
          // date: controller.text,
        );
      case 'company':
      case 'mobile':
      case 'signature':
        return super.fieldWidget;
      default:
        return QuestionCard(
          question: questionData.question,
          selectedValue: questionData.value,
          onChanged: (s) {
            cubit.onChanged(s, cubit.state.questions.indexOf(questionData));
          },
        );
    }

    // return super.fieldWidget;
  }

  @override
  FieldType get fieldType {
    switch (name) {
      case 'expectedDepartureTime':
        return FieldType.date;
      case 'fullName':
        return FieldType.text;

      default:
        return super.fieldType;
      // return;
    }
  }
}
