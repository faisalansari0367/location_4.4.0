import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MySlideAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  const MySlideAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
    // return AnimationConfiguration.synchronized(
    //   child: FadeInAnimation(
    //     curve: kCurve,
    //     delay: duration,
    //     duration: kDuration,
    //     child: SlideAnimation(
    //       duration: duration,
    //       verticalOffset: 10,
    //       child: child,
    //     ),
    //   ),
    // );
  }
}
