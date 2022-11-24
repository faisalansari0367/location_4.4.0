import 'package:flutter/material.dart';
import 'package:background_location/ui/forms/global_questionnaire_form/provider/provider.dart';
import 'package:background_location/ui/forms/global_questionnaire_form/widgets/global_questionnaire_form_body.dart';

/// {@template global_questionnaire_form_page}
/// A description for GlobalQuestionnaireFormPage
/// {@endtemplate}
class GlobalQuestionnaireFormPage extends StatelessWidget {
  /// {@macro global_questionnaire_form_page}
  const GlobalQuestionnaireFormPage({super.key});

  /// The static route for GlobalQuestionnaireFormPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const GlobalQuestionnaireFormPage());
  }
 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GlobalQuestionnaireFormNotifier(),
      child: const Scaffold(
        body: GlobalQuestionnaireFormView(),
      ),
    );
  }   
}

/// {@template global_questionnaire_form_view}
/// Displays the Body of GlobalQuestionnaireFormView
/// {@endtemplate}
class GlobalQuestionnaireFormView extends StatelessWidget {
  /// {@macro global_questionnaire_form_view}
  const GlobalQuestionnaireFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlobalQuestionnaireFormBody();
  }
}
