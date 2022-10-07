import 'package:background_location/constants/index.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ShowScannedData extends StatelessWidget {
  final String data;
  const ShowScannedData({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        padding: kPadding,
        child: Column(
          children: [
            Gap(10.h),
            Text(
              'Scanned Results',
              style: context.textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(20.h),
            Text(data, style: context.textTheme.headline6?.copyWith())
          ],
        ),
      ),
    );
  }
}
