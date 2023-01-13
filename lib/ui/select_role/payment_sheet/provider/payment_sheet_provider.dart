import 'package:bioplus/constants/index.dart';
import 'package:bioplus/features/webview/flutter_webview.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';

enum Subscriptions { monthly, yearly }

extension SubscriptionsExt on Subscriptions {
  bool get isMonthly => Subscriptions.monthly == this;
  bool get isYearly => Subscriptions.yearly == this;
}

class PaymentSheetNotifier extends BaseModel {
  final double monthlyPrice = 35.00;
  final double yearlyPrice = 350.00;

  bool _showPlanSelection = false;
  bool get showPlanSelection => _showPlanSelection;

  void setShowPlanSelection() {
    _showPlanSelection = !_showPlanSelection;
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
