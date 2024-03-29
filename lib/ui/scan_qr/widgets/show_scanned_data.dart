import 'package:bioplus/constants/index.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowScannedData extends StatelessWidget {
  final String data;
  const ShowScannedData({super.key, required this.data});

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
