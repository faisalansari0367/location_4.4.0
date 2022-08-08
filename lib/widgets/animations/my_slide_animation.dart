import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../constants/constans.dart';

class MySlideAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double? horizontalOffset, verticalOffset;
  const MySlideAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeIn,
    this.horizontalOffset,
    this.verticalOffset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.synchronized(
      child: FadeInAnimation(
        curve: kCurve,
        delay: duration,
        duration: duration,
        child: SlideAnimation(
          horizontalOffset: horizontalOffset,
          verticalOffset: verticalOffset,
          child: child,
        ),
      ),
    );
  }
}
