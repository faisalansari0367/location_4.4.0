// import 'package:flutter/material.dart';
// import 'package:flutter_expense_trackr/gen/assets.gen.dart';
// import 'package:flutter_expense_trackr/widgets/index.dart';
// import 'package:lottie/lottie.dart';

// import '../my_slide_animation.dart';

// class SomethingWentWrong extends StatefulWidget {
//   const SomethingWentWrong({Key? key}) : super(key: key);

//   @override
//   State<SomethingWentWrong> createState() => _SomethingWentWrongState();
// }

// class _SomethingWentWrongState extends State<SomethingWentWrong>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(vsync: this, duration: Duration(seconds: 5));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void onLoaded(LottieComposition composition) {
//     _controller
//       ..drive(CurveTween(curve: Curves.easeIn))
//       ..repeat();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MySlideAnimation(
//       child: Column(
//         children: [
//           Spacer(),
//           Lottie.asset(
//             Assets.animations.error,
//             controller: _controller,
//             animate: true,
//             frameRate: FrameRate(120),
//             onLoaded: onLoaded,
//           ),
//           SizedBox(height: 3.height),
//           Text(
//             'Something went wrong',
//             style: Theme.of(context).textTheme.headline6,
//           ),
//           Spacer(),
//         ],
//       ),
//     );
//   }
// }
