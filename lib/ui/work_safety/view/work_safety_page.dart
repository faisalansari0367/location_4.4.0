import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/work_safety/cubit/cubit.dart';
import 'package:bioplus/ui/work_safety/widgets/work_safety_body.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

/// {@template work_safety_page}
/// A description for WorkSafetyPage
/// {@endtemplate}
class WorkSafetyPage extends StatelessWidget {
  /// {@macro work_safety_page}
  const WorkSafetyPage({super.key});

  /// The static route for WorkSafetyPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const WorkSafetyPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkSafetyCubit(api: context.read<Api>()),
      child: const Scaffold(
        appBar: MyAppBar(title: Text('Work Safety')),
        body: WorkSafetyView(),
      ),
    );
  }
}

/// {@template work_safety_view}
/// Displays the Body of WorkSafetyView
/// {@endtemplate}
class WorkSafetyView extends StatelessWidget {
  /// {@macro work_safety_view}
  const WorkSafetyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkSafetyBody();
  }
}
