import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/geofence_delegation/provider/provider.dart';
import 'package:bioplus/ui/geofence_delegation/widgets/geofence_delegation_body.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

/// {@template geofence_delegation_page}
/// A description for GeofenceDelegationPage
/// {@endtemplate}
class GeofenceDelegationPage extends StatelessWidget {
  /// {@macro geofence_delegation_page}
  const GeofenceDelegationPage({super.key});

  /// The static route for GeofenceDelegationPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const GeofenceDelegationPage());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GeofenceDelegationNotifier(context),
      child: Scaffold(
        appBar: MyAppBar(
          title: Text(Strings.geofenceDelegation),
        ),
        body: const GeofenceDelegationView(),
      ),
    );
  }
}

/// {@template geofence_delegation_view}
/// Displays the Body of GeofenceDelegationView
/// {@endtemplate}
class GeofenceDelegationView extends StatelessWidget {
  /// {@macro geofence_delegation_view}
  const GeofenceDelegationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const GeofenceDelegationBody();
  }
}
