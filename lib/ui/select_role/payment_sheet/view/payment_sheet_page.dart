import 'package:bioplus/ui/select_role/payment_sheet/provider/provider.dart';
import 'package:bioplus/ui/select_role/payment_sheet/widgets/payment_page_view.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

/// {@template payment_sheet_page}
/// A description for PaymentSheetPage
/// {@endtemplate}
class PaymentSheetPage extends StatelessWidget {
  /// {@macro payment_sheet_page}
  const PaymentSheetPage({super.key, required this.role});

  final String role;

  /// The static route for PaymentSheetPage
  // static Route<dynamic> route() {
  //   return MaterialPageRoute<dynamic>(
  //     builder: (_) => PaymentSheetPage(
  //       role: role,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PaymentSheetNotifier(
        context,
        role: role,
      ),
      // child: const PaymentSheetBody(),
      child: const Scaffold(
        appBar: MyAppBar(),
        body: PaymentSheetView(),
      ),
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
    return const PaymentPageView();
  }
}
