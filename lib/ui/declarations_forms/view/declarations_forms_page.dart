import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/declarations_forms/cubit/cubit.dart';
import 'package:bioplus/ui/declarations_forms/widgets/declarations_forms_body.dart';
import 'package:flutter/material.dart';

/// {@template declarations_forms_page}
/// A description for DeclarationsFormsPage
/// {@endtemplate}
class DeclarationsFormsPage extends StatelessWidget {
  final LogbookFormModel form;

  /// {@macro declarations_forms_page}
  const DeclarationsFormsPage({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeclarationsFormsCubit(context, form: form),
      child: const Scaffold(
        body: DeclarationsFormsView(),
      ),
    );
  }
}

/// {@template declarations_forms_view}
/// Displays the Body of DeclarationsFormsView
/// {@endtemplate}
class DeclarationsFormsView extends StatelessWidget {
  /// {@macro declarations_forms_view}
  const DeclarationsFormsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const DeclarationsFormsBody();
  }
}
