import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/select_role/payment_sheet/provider/payment_sheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PaymentGetStarted extends StatelessWidget {
  const PaymentGetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Included in your subscription',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        _feature('3 PICS'),
        _feature('3 Geofences'),
        _feature('Free Gate Sign'),
        _feature('SOS'),
        _feature('Emergency Warning'),
        _feature('Vistor Logbook'),
        _feature('eCVD'),
        _feature('eLWD®'),
        _feature('WorkSAFETY®'),
        _feature('Desktop Access'),
        Gap(20.h),
        Center(
          child: MyElevatedButton(
            width: 70.width,
            text: 'Proceed to Checkout',
            onPressed: () async {
              context.read<PaymentSheetNotifier>().setShowPlanSelection();
            },
          ),
        )
      ],
    );
  }

  Widget _feature(String text) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            // color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.check,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
