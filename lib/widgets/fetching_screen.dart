import 'package:bioplus/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class FetchingScreen extends StatelessWidget {
  final bool messsageOnTop;
  final String? message;
  final Widget? subWidget;
  const FetchingScreen({
    super.key,
    this.message,
    this.messsageOnTop = false,
    this.subWidget,
  });

  @override
  Widget build(BuildContext context) {
    final messageWidget = Text(
      message ?? ' Fetching data from server...',
      textAlign: TextAlign.center,
      style: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (messsageOnTop) messageWidget,
        Center(
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Lottie.asset(
              'assets/animations/fetching_data.json',
              width: 90.width,
            ),
          ),
        ),
        Gap(20.h),
        if (!messsageOnTop) messageWidget,
        if (subWidget != null) ...[
          Gap(10.h),
          subWidget!,
        ]
      ],
    );
  }
}
