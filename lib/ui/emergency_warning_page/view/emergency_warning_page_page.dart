import 'package:bioplus/ui/emergency_warning_page/provider/provider.dart';
import 'package:bioplus/ui/emergency_warning_page/widgets/emergency_warning_page_body.dart';
import 'package:bioplus/ui/maps/location_service/maps_repo.dart';
import 'package:flutter/material.dart';

/// {@template emergency_warning_page_page}
/// A description for EmergencyWarningPagePage
/// {@endtemplate}
class EmergencyWarningPagePage extends StatelessWidget {
  /// {@macro emergency_warning_page_page}
  const EmergencyWarningPagePage({super.key});

  /// The static route for EmergencyWarningPagePage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const EmergencyWarningPagePage());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmergencyWarningPageNotifier(context, mapsRepo: context.read<MapsRepo>()),
      child: const Scaffold(
        body: EmergencyWarningPageView(),
      ),
    );
  }
}

/// {@template emergency_warning_page_view}
/// Displays the Body of EmergencyWarningPageView
/// {@endtemplate}
class EmergencyWarningPageView extends StatelessWidget {
  /// {@macro emergency_warning_page_view}
  const EmergencyWarningPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmergencyWarningPageBody();
  }
}
