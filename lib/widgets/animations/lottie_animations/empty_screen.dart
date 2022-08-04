// import 'package:flutter/material.dart';
// import 'package:flutter_expense_trackr/constans.dart';
// import 'package:flutter_expense_trackr/widgets/animations/my_slide_animation.dart';
// import 'package:flutter_expense_trackr/widgets/index.dart';
// import 'package:lottie/lottie.dart';

// class EmptyScreen extends StatefulWidget {
//   const EmptyScreen({Key? key}) : super(key: key);

//   @override
//   State<EmptyScreen> createState() => _EmptyScreenState();
// }

// class _EmptyScreenState extends State<EmptyScreen> with SingleTickerProviderStateMixin {
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

//   @override
//   Widget build(BuildContext context) {
//     return MySlideAnimation(
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Lottie.asset(
//             'assets/animations/sad-empty-box.json',
//             controller: _controller,
//             animate: true,
//             frameRate: FrameRate(120),
//             onLoaded: onLoaded,
//           ),
//           // SizedBox(
//           //   height: 1.height,
//           // ),
//           AnimatedPositioned(
//             duration: kDuration,
//             // top: 40.height,
//             bottom: 6.height,
//             // left: 41.5.width,
//             // left: MediaQuery.of(context).size.width / 2 - 40.width / 2,
//             // width: 100.width,
//             child: Text(
//               'No data found',
//               style: Theme.of(context).textTheme.headline6,
//             ),
//           ),
//           // Spascer(),
//         ],
//       ),
//     );
//   }

//   void onLoaded(LottieComposition composition) {
//     _controller
//       ..drive(CurveTween(curve: Curves.easeIn))
//       ..repeat();
//   }
// }
