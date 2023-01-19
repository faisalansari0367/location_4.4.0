import 'package:bioplus/constants/strings.dart';
import 'package:bioplus/ui/edec_forms/page/livestock_waybill/provider/provider.dart';
import 'package:bioplus/ui/edec_forms/page/livestock_waybill/widgets/livestock_waybill_body.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

/// {@template livestock_waybill_page}
/// A description for LivestockWaybillPage
/// {@endtemplate}
class LivestockWaybillPage extends StatelessWidget {
  /// {@macro livestock_waybill_page}
  const LivestockWaybillPage({super.key});

  /// The static route for LivestockWaybillPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const LivestockWaybillPage());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LivestockWaybillNotifier(context),
      child: Scaffold(
        appBar: MyAppBar(
          title: Text(Strings.livestockWaybillDeclaration),
        ),
        body: const LivestockWaybillView(),
      ),
    );
  }
}

/// {@template livestock_waybill_view}
/// Displays the Body of LivestockWaybillView
/// {@endtemplate}
class LivestockWaybillView extends StatelessWidget {
  /// {@macro livestock_waybill_view}
  const LivestockWaybillView({super.key});

  @override
  Widget build(BuildContext context) {
    return const LivestockWaybillBody();
  }
}
