import 'package:bioplus/constants/my_decoration.dart';
import 'package:flutter/material.dart';

class DialogLayout extends StatelessWidget {
  final Widget child;

  const DialogLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: MyDecoration.dialogShape,
      child: child,
    );
  }
}
