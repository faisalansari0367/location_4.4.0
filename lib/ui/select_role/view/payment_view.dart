import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/features/webview/flutter_webview.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BuyServiceRoleView extends StatelessWidget {
  final String serviceRole;
  const BuyServiceRoleView({super.key, required this.serviceRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service role subscription'),
      ),
      body: Padding(
        padding: kPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Service role subscription for: $serviceRole'),
            Gap(20.h),
            Text(
              'Select your subscription plan',
              style: context.textTheme.headline5,
            ),
            Gap(80.h),
            // MyListTile(text: 'Monthly: \$35', onTap: () async {}),
            _priceTile(context, 'Monthly', '35'),
            Gap(50.h),
            _priceTile(context, 'Annual', '350'),
          ],
        ),
      ),
    );
  }

  Future<void> createSubscription(BuildContext context) async {
    final result = await context.read<Api>().createStripeSession();
    result.when(
      success: (data) {
        Get.to(
          () => Webview(url: data),
        );
      },
      failure: (e) => DialogService.failure(error: e),
    );
  }

  Widget _priceTile(BuildContext context, String duration, String price) {
    return InkWell(
      onTap: () async {
        await createSubscription(context);
      },
      child: Container(
        padding: kPadding,
        // margin: kPadding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.theme.backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: context.theme.primaryColor),
        ),
        child: Row(
          children: [
            Text(
              duration,
              style: context.textTheme.headline5,
            ),
            const Spacer(),
            Text(
              '\$$price',
              style: context.textTheme.headline5
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            // const Text('Yearly'),
          ],
        ),
      ),
    );
  }
}
