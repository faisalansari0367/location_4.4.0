import 'package:bioplus/constants/index.dart';
import 'package:bioplus/theme/color_constants.dart';
import 'package:bioplus/ui/select_role/payment_sheet/provider/payment_sheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PaymentGetStarted extends StatelessWidget {
  const PaymentGetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentSheetNotifier>(
      builder: (context, value, child) {
        if (value.baseState.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        return SingleChildScrollView(
          padding: kPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 00.w, vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.plan?.role?.toUpperCase() ?? '',
                  style: const TextStyle(
                    fontSize: 17,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(140, 0, 0, 0),
                  ),
                ),
              ),
              Text(
                // '\$${value.plan?.amount ?? 0}.00',
                value.price,
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value.plan?.paymentType.name.capitalize! ?? '',
                style: const TextStyle(
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
                child: Text(
                  'Everything In Starter Plan'.capitalizeFirst!,
                  style: const TextStyle(
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

              ...value.planData.entries.map((e) {
                return _feature(e.value['title'], e.value['description']);
              }),

              // _feature('3 PICS'),
              // _feature('3 Geofences'),
              // _feature('Free Gate Sign'),
              // _feature('SOS'),
              // _feature('Emergency Warning'),
              // _feature('Vistor Logbook'),
              // _feature('eCVD'),
              // _feature('eLWD®'),
              // _feature('WorkSAFETY®'),
              // _feature('Desktop Access'),
              Gap(20.h),
              Center(
                child: MyElevatedButton(
                  width: 70.width,
                  // color: const Color.fromARGB(217, 0, 0, 0),
                  color: kPrimaryColor,
                  text: 'Proceed to Checkout',
                  onPressed: () async {
                    context.read<PaymentSheetNotifier>().setShowPlanSelection();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _feature(String text, String description) {
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
                Text(
                  description,
                  style: const TextStyle(
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
