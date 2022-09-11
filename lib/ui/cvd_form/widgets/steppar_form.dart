import 'package:flutter/material.dart';

import 'form_stepper.dart';

class StepparForm extends StatelessWidget {
  final List<FormStepper> steps;

  const StepparForm({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stepper(
      steps: steps,
    );
  }
}
