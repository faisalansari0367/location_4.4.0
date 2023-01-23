import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/select_role/payment_sheet/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GovernmentCode extends StatelessWidget {
  const GovernmentCode({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentSheetNotifier>(context);
    return Padding(
      padding: kPadding,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Access Code',
              style: context.textTheme.headline6,
            ),
            Gap(10.h),
            MyTextField(
              onChanged: provider.setGovernmentCode,
            ),
            Gap(20.h),
            MyElevatedButton(
              onPressed: () async {
                if (provider.governmentCode == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid code'),
                    ),
                  );
                } else if (provider.governmentCode?.isEmpty ?? true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid code'),
                    ),
                  );
                } else {
                  await provider.createSubscription();
                }
              },
              // style: ElevatedButton.styleFrom(
              //   shape: const StadiumBorder(),
              //   minimumSize: Size(70.width, 50),
              // ),
              text: 'Submit',
            ),
          ],
        ),
      ),
    );
  }
}
