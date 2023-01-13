// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/theme/color_constants.dart';
import 'package:bioplus/ui/select_role/payment_sheet/provider/payment_sheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentSubscriptionTile extends StatelessWidget {
  final double amount;
  final Subscriptions subscription;
  final bool? isSelected;
  final ValueChanged<Subscriptions> onChanged;

  const PaymentSubscriptionTile({
    super.key,
    required this.amount,
    required this.subscription,
    this.isSelected = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final price = '\$$amount${0}';
    // final price = double.parse(amount.toStringAsFixed(2)).toString();

    return InkWell(
      onTap: () => onChanged(subscription),
      child: AnimatedContainer(
        duration: kDuration,
        curve: kCurve,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: (isSelected ?? false) ? kPrimaryColor : Colors.grey.shade100,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_header(), _radioButton()],
            ),
            _priceHeader(price),
            Gap(10.h),
            _buildFreeTrial(),
            Gap(8.h),
            _description(price)
          ],
        ),
      ),
    );
  }

  Text _description(String price) {
    return Text(
      'then $price per $_typeDuration. Cancel any time',
      style: TextStyle(
        color: Colors.grey.shade600,
      ),
    );
  }

  Container _buildFreeTrial() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6.w,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff2db973).withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Text(
        '1 week free trial'.toUpperCase(),
        style: const TextStyle(
          color: Color(0xff2db973),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Text _priceHeader(String price) {
    return Text(
      '$price/${subscription.name}',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  Text _header() {
    return Text(
      _type.toUpperCase(),
      style: TextStyle(
        color: Colors.grey.shade500,
        letterSpacing: 2,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String get _typeDuration => subscription.isMonthly ? 'month' : 'year';

  String get _type => subscription.isMonthly ? 'Monthly' : 'Yearly';

  Widget _radioButton() {
    return Radio(
      activeColor: kPrimaryColor,
      value: isSelected,
      groupValue: true,
      onChanged: (s) {
        onChanged(subscription);
      },
    );
  }
}
