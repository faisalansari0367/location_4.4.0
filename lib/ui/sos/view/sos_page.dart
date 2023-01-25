import 'package:bioplus/constants/strings.dart';
import 'package:bioplus/ui/sos/provider/provider.dart';
import 'package:bioplus/ui/sos/widgets/sos_body.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

/// {@template sos_page}
/// A description for SosPage
/// {@endtemplate}
class SosPage extends StatelessWidget {
  /// {@macro sos_page}
  const SosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SosNotifier(context),
      child: const SosView(),
      // child: Scaffold(
      //   appBar: MyAppBar(
      //     title: Text(Strings.sosRecords),
      //     actions: [

      //     ],
      //     elevation: 5,
      //   ),
      //   body: const SosView(),
      // ),
    );
  }
}

/// {@template sos_view}
/// Displays the Body of SosView
/// {@endtemplate}
class SosView extends StatelessWidget {
  /// {@macro sos_view}
  const SosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text(Strings.sosRecords),
        actions: [
          IconButton(
            onPressed: () => context.read<SosNotifier>().generateCsv(),
            icon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                'assets/icons/export.png',
              ),
            ),
          ),
        ],
      ),
      body: const SosBody(),
    );
  }
}
