import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/select_role/payment_sheet/provider/payment_sheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PaymentGetStarted extends StatelessWidget {
  const PaymentGetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: kPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 00.w, vertical: 5.h),
            decoration: BoxDecoration(
              // color: kPrimaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Producer'.toUpperCase(),
              style: const TextStyle(
                fontSize: 17,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(140, 0, 0, 0),
              ),
            ),
          ),
          const Text(
            '\$${35.0}0',
            style: TextStyle(
              fontSize: 40,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text(
            'Per Month',
            style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(147, 0, 0, 0),
              fontWeight: FontWeight.w500,
            ),
          ),
          Gap(20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: const Color.fromARGB(217, 0, 0, 0),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Text(
              'Everything of Starter Plan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Gap(15.h),
          const Text(
            'Additional Features:',
            style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(147, 0, 0, 0),
              fontWeight: FontWeight.w500,
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
              color: const Color.fromARGB(217, 0, 0, 0),
              text: 'Proceed to Checkout',
              onPressed: () async {
                context.read<PaymentSheetNotifier>().setShowPlanSelection();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _feature(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.check,
              color: Colors.teal,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(5.h),
                const Text(
                  'lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
