import 'package:flutter/material.dart';
import 'package:bioplus/ui/forms/global_form/cubit/cubit.dart';
import 'package:bioplus/ui/forms/global_form/widgets/global_form_body.dart';

/// {@template global_form_page}
/// A description for GlobalFormPage
/// {@endtemplate}
class GlobalFormPage extends StatelessWidget {
  /// {@macro global_form_page}
  const GlobalFormPage({super.key});

  /// The static route for GlobalFormPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const GlobalFormPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GlobalFormCubit(),
      child: const Scaffold(
        body: GlobalFormView(),
      ),
    );
  }    
}

/// {@template global_form_view}
/// Displays the Body of GlobalFormView
/// {@endtemplate}
class GlobalFormView extends StatelessWidget {
  /// {@macro global_form_view}
  const GlobalFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlobalFormBody();
  }
}
