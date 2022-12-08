import 'package:bioplus/ui/forms/warakirri_entry_form/provider/provider.dart';
import 'package:bioplus/ui/forms/warakirri_entry_form/widgets/warakirri_entry_form_body.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../maps/models/polygon_model.dart';

/// {@template warakirri_entry_form_page}
/// A description for WarakirriEntryFormPage
/// {@endtemplate}
class WarakirriEntryFormPage extends StatelessWidget {
  final String zoneId;
  final int? logrecordId;
  final PolygonModel? polygon;

  /// {@macro warakirri_entry_form_page}
  const WarakirriEntryFormPage({
    super.key,
    required this.zoneId,
    this.logrecordId,
    this.polygon,
  });

  /// The static route for WarakirriEntryFormPage
  // static Route<dynamic> route() {
  //   return MaterialPageRoute<dynamic>(
  //     builder: (_) => WarakirriEntryFormPage(
  //       zoneId: zoneId,
  //       logrecordId: logrecordId,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WarakirriEntryFormNotifier(
        context,
        zoneId: zoneId,
        logrecordId: logrecordId,
        polygon: polygon,
      ),
      child: Scaffold(
        appBar: MyAppBar(
          showBackButton: true,
          elevation: 3,
          backgroundColor: context.theme.primaryColor,
          title: Text(
            'Warakirri Declaration Form',
          ),
        ),
        body: WarakirriEntryFormView(),
      ),
    );
  }
}

/// {@template warakirri_entry_form_view}
/// Displays the Body of WarakirriEntryFormView
/// {@endtemplate}
class WarakirriEntryFormView extends StatelessWidget {
  /// {@macro warakirri_entry_form_view}
  const WarakirriEntryFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return const WarakirriEntryFormBody();
  }
}
