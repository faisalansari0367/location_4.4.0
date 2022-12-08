import 'package:bioplus/ui/forms/global_questionnaire_form/provider/provider.dart';
import 'package:bioplus/ui/forms/global_questionnaire_form/widgets/global_questionnaire_form_body.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// {@template global_questionnaire_form_page}
/// A description for GlobalQuestionnaireFormPage
/// {@endtemplate}
class GlobalQuestionnaireFormPage extends StatelessWidget {
  /// {@macro global_questionnaire_form_page}
  final String zoneId;
  final int? logrecordId;
  const GlobalQuestionnaireFormPage({super.key, required this.zoneId, this.logrecordId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GlobalQuestionnaireFormNotifier(context, zoneId: zoneId, logrecordId: logrecordId),
      child: Scaffold(
        appBar: MyAppBar(
          title: Text('Declaration'),
          elevation: 3,
          backgroundColor: context.theme.primaryColor,
        ),
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
    return LayoutBuilder(builder: (context, constrains) {
      return const GlobalQuestionnaireFormBody();
    });
  }
}
