import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/select_role/payment_sheet/provider/provider.dart';
import 'package:bioplus/ui/select_role/payment_sheet/widgets/payment_subscription_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// {@template payment_sheet_body}
/// Body of the PaymentSheetPage.
///
/// Add what it does
/// {@endtemplate}
class PaymentSheetBody extends StatelessWidget {
  /// {@macro payment_sheet_body}
  const PaymentSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentSheetNotifier>(
      builder: (context, state, child) {
        return Padding(
          padding: kPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _chooseYourPlan(context),
              Gap(20.h),

              ...state.plans.map(
                (plan) => Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: PaymentSubscriptionTile(
                    amount: (plan.amount ?? 0.0).toDouble(),
                    subscription: plan.paymentType,
                    isSelected: state.selectedPlan?.id == plan.id,
                    onChanged: () => state.setPlan(plan),
                  ),
                ),
              ),

              // PaymentSubscriptionTile(
              //   amount: state.monthlyPrice,
              //   subscription: Subscriptions.monthly,
              //   isSelected: state.subscription?.isMonthly,
              //   onChanged: state.setPlan,
              // ),
              // Gap(20.h),
              // PaymentSubscriptionTile(
              //   amount: state.yearlyPrice,
              //   subscription: Subscriptions.yearly,
              //   isSelected: state.subscription?.isYearly,
              //   onChanged: state.setPlan,
              // ),
              // Gap(20.h),
              const Spacer(),
              _checkoutButton(state),
              Gap(20.h),
            ],
          ),
        );
      },
    );
  }

  ElevatedButton _checkoutButton(PaymentSheetNotifier state) {
    return ElevatedButton(
      onPressed: state.selectedPlan == null ? null : state.createSubscription,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        minimumSize: Size(60.width, 5.height),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Continue to checkout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Gap(10.h),
          const Icon(Icons.chevron_right_outlined),
        ],
      ),

      // child: Row(),
    );
  }

  Row _chooseYourPlan(BuildContext context) {
    return Row(
      children: [
        Text(
          'Choose your plan'.toUpperCase(),
          style: context.textTheme.headline6?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.5,
          ),
        ),
        const Spacer(),
        // AnimatedButton(
        //   scale: 0.8,
        //   onTap: Get.back,
        //   child: Container(
        //     padding: EdgeInsets.all(5.r),
        //     decoration: BoxDecoration(
        //       color: Colors.grey.shade200,
        //       shape: BoxShape.circle,
        //     ),
        //     child: const Icon(Icons.clear),
        //   ),
        // ),
      ],
    );
  }
}
