import 'package:bioplus/ui/select_role/payment_sheet/payment_sheet.dart';
import 'package:flutter/material.dart';

class PaymentPageView extends StatefulWidget {
  const PaymentPageView({super.key});

  @override
  State<PaymentPageView> createState() => _PaymentPageViewState();
}

class _PaymentPageViewState extends State<PaymentPageView> {
  // PageController controller = PageController();
  double currentPageValue = 0.0;

  @override
  void initState() {
    final provider = context.read<PaymentSheetNotifier>().pageController;

    provider.addListener(() {
      setState(() {
        currentPageValue = provider.page ?? 0.0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PaymentSheetNotifier>();
    return PageView.builder(
      itemBuilder: _itemBuilder,
      physics: const NeverScrollableScrollPhysics(),
      controller: provider.pageController,
      itemCount: provider.pages.length,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final provider = context.read<PaymentSheetNotifier>();
    return Transform(
      transform: Matrix4.identity()..rotateX(currentPageValue - index),
      child: provider.pages[index],
    );
  }
}
