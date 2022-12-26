import 'package:bioplus/widgets/biosecure_logo.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

// import '../../../widgets/my_appbar.dart';
import '../dashboard.dart';

/// {@template dashboard_page}
/// A description for DashboardPage
/// {@endtemplate}
class DashboardPage extends StatelessWidget {
  /// {@macro dashboard_page}
  const DashboardPage({super.key});

  /// The static route for DashboardPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const DashboardPage());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardNotifier(context),
      child: LayoutBuilder(
        builder: (context, constraints) => const Scaffold(
          appBar: MyAppBar(
            showBackButton: false,
            centreTitle: true,
            title: SizedBox(
              height: 50,
              child: AnimationConfiguration.synchronized(
                child: ScaleAnimation(
                  scale: 0.7,
                  curve: Curves.easeIn,
                  child: BioSecureLogo(),
                ),
              ),
            ),
          ),
          body: DashboardView(),
        ),
      ),
    );
  }
}

/// {@template dashboard_view}
/// Displays the Body of DashboardView
/// {@endtemplate}
class DashboardView extends StatelessWidget {
  /// {@macro dashboard_view}
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardBody();
  }
}
