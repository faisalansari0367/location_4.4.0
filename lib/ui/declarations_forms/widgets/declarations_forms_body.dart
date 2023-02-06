import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/declarations_forms/cubit/cubit.dart';
import 'package:bioplus/ui/declarations_forms/widgets/declaration_form_card.dart';
import 'package:bioplus/widgets/signature/signature_widget.dart';
import 'package:bioplus/widgets/user_info.dart';
import 'package:flutter/material.dart';

/// {@template declarations_forms_body}
/// Body of the DeclarationsFormsPage.
///
/// Add what it does
/// {@endtemplate}
class DeclarationsFormsBody extends StatefulWidget {
  /// {@macro declarations_forms_body}
  const DeclarationsFormsBody({super.key});

  @override
  State<DeclarationsFormsBody> createState() => _DeclarationsFormsBodyState();
}

class _DeclarationsFormsBodyState extends State<DeclarationsFormsBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeclarationsFormsCubit, DeclarationsFormsState>(
      builder: (context, state) {
        final cubit = context.read<DeclarationsFormsCubit>();

        if (state.forms.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: kPadding,
          child: Column(
            children: [
              UserInfo(
                user: cubit.user,
                expectedDepartureTime: cubit.form.expectedDepartureTime,
              ),
              if (cubit.getFormByType() != null)
                for (final formKey in cubit.getFormByType()!.formKeys)
                  _buildCard(formKey),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(FormKeys formKey) {
    final cubit = context.read<DeclarationsFormsCubit>();
    // final form = cubit.getFormByType();
    final logbookForm = cubit.form;

    String? answer = '';

    final value = logbookForm.toJson()[formKey.key];

    switch (formKey.dataType) {
      case 'array':
        answer = (value as List).join(', ');
        if (answer.isEmpty) answer = 'No';
        break;
      case 'boolean':
        answer = value ? 'Yes' : 'No';
        break;
      default:
        answer = value;
    }

    if (formKey.key == 'signature') {
      if (answer?.isEmpty ?? true) return Container();
      return SignatureWidget(
        signature: answer,
      );
    }

    return DeclarationFormCard(
      question: '${formKey.index}. ${formKey.description}',
      value: answer,
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
