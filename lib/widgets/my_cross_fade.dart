import 'package:bioplus/constants/constans.dart';
import 'package:bioplus/extensions/size_config.dart';
import 'package:flutter/material.dart';

class MyCrossFade extends StatelessWidget {
  final Widget child;
  final Widget? placeHolder;
  final bool isLoading;
  const MyCrossFade({super.key, this.isLoading = false, required this.child, this.placeHolder});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      // firstCurve: kCurve,
      // secondCurve: kCurve,
      duration: kDuration,
      // crossFadeState: !isLoading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      // firstChild: placeHolder ?? _loader(),
      // secondChild: child,
      child: isLoading ? _loader() : child,
    );
  }

  Widget _loader() => SizedBox.square(
        dimension: 50.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        // dimension: 40.height,
      );
}
