import 'package:background_location/ui/cvd_form/models/cvd_form_data.dart';
import 'package:flutter/material.dart';

class FormStepper extends Step {
  final List<CvdFormData> formDataList;

  final String heading;
  final Widget? actions;
  final bool isActive;
  FormStepper({
    this.actions,
    this.formDataList = const [],
    required this.heading,
    // required this.content,
    this.isActive = false,
  }) : super(
          content: SingleChildScrollView(
            child: Column(
              children: [
                ...formDataList.map((e) => e.fieldWidget).toList(),
                if (actions != null) actions,
              ],
            ),
          ),
          title: Text(heading),
          isActive: isActive,
          // state: StepState``
        );
}
