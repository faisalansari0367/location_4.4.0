import 'package:flutter/material.dart';
import 'package:bioplus/ui/forms/global_form/cubit/cubit.dart';

/// {@template global_form_body}
/// Body of the GlobalFormPage.
///
/// Add what it does
/// {@endtemplate}
class GlobalFormBody extends StatelessWidget {
  /// {@macro global_form_body}
  const GlobalFormBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalFormCubit, GlobalFormState>(
      builder: (context, state) {
        return Center(child: Text(state.customProperty));
      },
    );
  }
}
