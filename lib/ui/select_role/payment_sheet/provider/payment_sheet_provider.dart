import 'dart:convert';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/features/webview/flutter_webview.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/ui/select_role/payment_sheet/payment_sheet.dart';
import 'package:bioplus/ui/select_role/payment_sheet/widgets/government_code.dart';
import 'package:bioplus/ui/select_role/payment_sheet/widgets/payment_get_started.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/dialogs/success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

// enum Subscriptions { monthly, yearly }

// extension SubscriptionsExt on Subscriptions {
//   bool get isMonthly => Subscriptions.monthly == this;
//   bool get isYearly => Subscriptions.yearly == this;
// }

class PaymentSheetNotifier extends BaseModel {
  final String role;
  final double monthlyPrice = 35.00;
  final double yearlyPrice = 350.00;
  final PageController pageController = PageController();
  final planData = <String, dynamic>{};
  Plan? plan;
  PlanDetailsModel? planDetailsModel;
  String? governmentCode;

  Plan? selectedPlan;

  final pages = const <Widget>[
    PaymentGetStarted(),
    PaymentSheetBody(),
    GovernmentCode(),
  ];

  final bool _showPlanSelection = false;
  bool get showPlanSelection => _showPlanSelection;

  List<Plan> get plans => planDetailsModel?.getPlanByRole(role) ?? [];

  void setGovernmentCode(String code) {
    governmentCode = code;
    notifyListeners();
  }

  void setShowPlanSelection() {
    if (role == 'Government') {
      selectedPlan = plan;
      pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 1000),
        curve: kCurve,
      );
      return;
    }

    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 1000),
      curve: kCurve,
    );

    notifyListeners();
  }

  Subscriptions? _subscription;

  PaymentSheetNotifier(super.context, {required this.role}) {
    getPlanDetails();
  }
  Subscriptions? get subscription => _subscription;

  void setPlan(Plan plan) {
    selectedPlan = plan;
    notifyListeners();
  }

  String get price {
    if (plan == null) {
      return '\$0.00';
    }
    if (['corporate', 'government'].contains(role.toLowerCase())) {
      return 'P.O.A.';
    }
    return '\$${plan!.amount!.toStringAsFixed(2)}';
  }

  bool get isRoleGovernment => role == 'Government';

  Future<void> createSubscription() async {
    final result = await api.createStripeSession(
      selectedPlan!.priceId!,
      selectedPlan!.paymentMode!,
      role: role,
      governmentCode: governmentCode,
    );
    result.when(
      success: (data) async {
        if (isRoleGovernment) {
          Get.back();
          Get.snackbar('Success', 'Government Role Added');
          return;
        }

        await Get.to(
          () => Webview(
            url: data,
            onNavigationRequest: _onNavigationRequest,
          ),
        );
        Get.back();
        Get.back();
        Get.back();
      },
      failure: (e) => DialogService.failure(error: e),
    );
  }

  NavigationDecision _onNavigationRequest(NavigationRequest request) {
    if (request.url.startsWith('https:')) {
      final success = request.url == 'https://google.com/';
      final error = request.url == 'https://youtube.com/';
      if (success) {
        DialogService.showDialog(
          child: SuccessDialog(
            onTap: () {
              Get.back();
            },
            message: 'Payment Successful',
          ),
        );
      }

      if (error) {
        Get.back();
        DialogService.showDialog(
          child: SuccessDialog(
            onTap: Get.back,
            message: 'Payment Failed',
          ),
        );
      }
    }

    return NavigationDecision.navigate;
  }

  Future<void> getPlanDetails() async {
    setLoading(true);
    final result = await api.getPlanDetails();
    result.when(
      success: (data) async {
        final monthlyPlan = data.getPlanByRole(role)?.where((element) {
          if (element.role == 'Government') return true;
          return element.paymentType.isMonthly;
        });
        if (monthlyPlan?.isNotEmpty ?? false) {
          plan = monthlyPlan?.first;
        }

        planDetailsModel = data;
        notifyListeners();
        await loadPriceListJson(plan?.toJson() ?? {});
      },
      failure: (e) => DialogService.failure(error: e),
    );
    setLoading(false);
  }

  Future<void> loadPriceListJson(Map plan) async {
    final String result =
        await rootBundle.loadString('assets/json/price_list.json');
    final json = jsonDecode(result) as Map<String, dynamic>;
    _addPicAndGeofence(plan);
    json.forEach((key, value) {
      if (plan[key] ?? false) {
        planData.addAll({key: value});
      }
    });
    notifyListeners();
  }

  void _addPicAndGeofence(Map<dynamic, dynamic> plan) {
    if (plan.containsKey('pic')) {
      if (plan['pic'] == 0) return;
      planData.addAll({
        'pic': {
          'title': '${this.plan?.pic} PICS',
          'description': 'You will get ${this.plan?.pic} PICS',
        }
      });
    }
    if (plan.containsKey('geofence')) {
      if (plan['geofence'] == 0) return;
      planData.addAll({
        'geofence': {
          'title': '${this.plan?.geofence} Geofences',
          'description': 'You will get ${this.plan?.geofence} Geofences',
        }
      });
    }
  }

  // print(planData);
  // @override
  // }
}
