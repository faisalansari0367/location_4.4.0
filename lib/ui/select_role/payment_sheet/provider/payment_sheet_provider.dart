import 'package:bioplus/constants/index.dart';
import 'package:bioplus/features/webview/flutter_webview.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/ui/select_role/payment_sheet/payment_sheet.dart';
import 'package:bioplus/ui/select_role/payment_sheet/widgets/payment_get_started.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';

enum Subscriptions { monthly, yearly }

extension SubscriptionsExt on Subscriptions {
  bool get isMonthly => Subscriptions.monthly == this;
  bool get isYearly => Subscriptions.yearly == this;
}

class PaymentSheetNotifier extends BaseModel {
  final double monthlyPrice = 35.00;
  final double yearlyPrice = 350.00;
  final PageController pageController = PageController();

  final pages = const <Widget>[
    PaymentGetStarted(),
    PaymentSheetBody(),
  ];

  final bool _showPlanSelection = false;
  bool get showPlanSelection => _showPlanSelection;

  void setShowPlanSelection() {
    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 1000),
      curve: kCurve,
    );

    notifyListeners();
  }

  Subscriptions? _subscription;

  PaymentSheetNotifier(super.context);
  Subscriptions? get subscription => _subscription;

  void setSubscription(Subscriptions subscription) {
    _subscription = subscription;
    notifyListeners();
  }

  Future<void> createSubscription() async {
    final result = await api.createStripeSession();
    result.when(
      success: (data) => Get.to(
        () => Webview(url: data),
      ),
      failure: (e) => DialogService.failure(error: e),
    );
  }
}
