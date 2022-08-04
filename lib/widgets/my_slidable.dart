// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

// class MySlidable extends StatelessWidget {
//   final void Function()  onPressed, onDismissed;
//   final Widget child;

//   const MySlidable({
//     Key? key,
//     required this.child,
//     required this.onPressed,
//     required this.onDismissed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Slidable(
//       key: UniqueKey(),

//       //  dismissible: DismissiblePane(onDismissed: () {}),
//       endActionPane: ActionPane(
//         extentRatio: 1 / 5,
//         motion: const ScrollMotion(),
//         children: [
//           Expanded(
//             child: IconButton(
//               color: Color.fromARGB(255, 255, 125, 116),
//               icon: Icon(Icons.delete),
//               onPressed: onPressed,
//             ),
//           )
//         ],
//       ),
//       child: child,
//     );
//   }
// }
