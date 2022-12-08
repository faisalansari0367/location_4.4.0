import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/sos_warning/cubit/cubit.dart';
import 'package:bioplus/ui/sos_warning/widgets/sos_warning_body.dart';
import 'package:flutter/material.dart';

/// {@template sos_warning_page}
/// A description for SosWarningPage
/// {@endtemplate}
class SosWarningPage extends StatelessWidget {
  /// {@macro sos_warning_page}
  const SosWarningPage({super.key});

  /// The static route for SosWarningPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const SosWarningPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SosWarningCubit(
        context.read<Api>(),
      ),
      // child: const Scaffold(
      //   body: SosWarningView(),
      // ),
      child: SosWarningView(),
    );
  }
}

/// {@template sos_warning_view}
/// Displays the Body of SosWarningView
/// {@endtemplate}
class SosWarningView extends StatelessWidget {
  /// {@macro sos_warning_view}
  const SosWarningView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SosWarningBody();
  }
}
