import 'package:bioplus/ui/select_role/payment_sheet/provider/provider.dart';
import 'package:bioplus/ui/select_role/payment_sheet/widgets/payment_get_started.dart';
import 'package:bioplus/ui/select_role/payment_sheet/widgets/payment_sheet_body.dart';
import 'package:flutter/material.dart';

/// {@template payment_sheet_page}
/// A description for PaymentSheetPage
/// {@endtemplate}
class PaymentSheetPage extends StatelessWidget {
  /// {@macro payment_sheet_page}
  const PaymentSheetPage({super.key});

  /// The static route for PaymentSheetPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const PaymentSheetPage());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PaymentSheetNotifier(context),
      child: const PaymentSheetBody(),
      // child: const Scaffold(
      //   body: PaymentSheetView(),
      // ),
    );
  }
}

/// {@template payment_sheet_view}
/// Displays the Body of PaymentSheetView
/// {@endtemplate}
class PaymentSheetView extends StatelessWidget {
  /// {@macro payment_sheet_view}
  const PaymentSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaymentSheetBody();
  }
}
