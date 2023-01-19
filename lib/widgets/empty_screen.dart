import 'package:bioplus/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class EmptyScreen extends StatelessWidget {
  final bool messsageOnTop;
  final String? message;
  final Widget? subWidget;
  const EmptyScreen({super.key, this.message, this.messsageOnTop = false, this.subWidget});

  @override
  Widget build(BuildContext context) {
    final messageWidget = Text(
      message ?? ' No data found',
      textAlign: TextAlign.center,
      style: context.textTheme.headline6?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (messsageOnTop) messageWidget,
        Center(
          child: Lottie.asset(
            'assets/animations/empty-state.json',
            width: 90.width,
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
