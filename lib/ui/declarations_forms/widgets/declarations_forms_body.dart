import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/declarations_forms/cubit/cubit.dart';
import 'package:bioplus/ui/declarations_forms/widgets/declaration_form_card.dart';
import 'package:flutter/material.dart';

/// {@template declarations_forms_body}
/// Body of the DeclarationsFormsPage.
///
/// Add what it does
/// {@endtemplate}
class DeclarationsFormsBody extends StatelessWidget {
  /// {@macro declarations_forms_body}
  const DeclarationsFormsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeclarationsFormsCubit, DeclarationsFormsState>(
      builder: (context, state) {
        final cubit = context.read<DeclarationsFormsCubit>();
        final form = cubit.getFormByType();
        final logbookForm = cubit.form;
        // final values = logbookForm.toJson();

        return Column(
          children: [
            // ..._buildFormCards(state.forms, values),
            // for(final form in state.forms)

            // DeclarationFormCard(question: ),

            _buildCard(
              logbookForm.keys.userTravelingAlong,
              logbookForm.usersTravellingAlong?.join(', '),
              form,
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(String key, String? value, DeclarationForms form) {
    String question = '';

    for (final formKey in form.formKeys) {
      if (formKey.key == key) {
        question = formKey.description;
      }
    }

    return DeclarationFormCard(
      question: question,
      value: value,
    );
  }

  List<Widget> _buildFormCards(
    List<DeclarationForms> forms,
    Map<String, dynamic> values,
  ) {
    final List<Widget> widgets = [];
    for (final form in forms) {
      for (final formKey in form.formKeys) {
        final card = DeclarationFormCard(
          question: formKey.description,
          value: getValue(values[formKey.key]),
        );
        widgets.add(card);
      }
    }
    return widgets;
  }

  String? getValue(dynamic value) {
    if (value == null) return null;

    if (value is List<String>) {
      if (value.isEmpty) return null;
      return value.join(', ');
    } else if (value is String) {
      return value;
    }
    return null;
  }
}
