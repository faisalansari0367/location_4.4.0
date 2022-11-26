import 'package:background_location/ui/forms/warakirri_entry_form/provider/provider.dart';
import 'package:background_location/ui/forms/warakirri_entry_form/widgets/warakirri_entry_form_body.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// {@template warakirri_entry_form_page}
/// A description for WarakirriEntryFormPage
/// {@endtemplate}
class WarakirriEntryFormPage extends StatelessWidget {
  final String zoneId;
  final int? logrecordId;

  /// {@macro warakirri_entry_form_page}
  const WarakirriEntryFormPage({super.key, required this.zoneId, this.logrecordId});

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
