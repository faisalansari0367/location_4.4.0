import 'package:flutter/material.dart';
import 'package:background_location/ui/forms/global_questionnaire_form/provider/provider.dart';

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
    return Consumer<GlobalQuestionnaireFormNotifier>(
      builder: (context, state, child) {
        return Container();
        // return Center(child: Text(state.count.toString()));
      },
    );
  }
}
