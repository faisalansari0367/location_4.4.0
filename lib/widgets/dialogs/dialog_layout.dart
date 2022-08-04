import 'package:flutter/material.dart';

import '../../constants/my_decoration.dart';

class DialogLayout extends StatelessWidget {
  final Widget child;

  const DialogLayout({Key? key, required this.child}) : super(key: key);

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
