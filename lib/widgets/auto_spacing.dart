import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AutoSpacing extends StatelessWidget {
  final List<Widget> children;
  final Widget? spacing, startSpacing;

  const AutoSpacing({Key? key, required this.children, this.spacing, this.startSpacing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: addSizedBox(),
    );
  }

  List<Widget> addSizedBox() {
    if (children.isEmpty) return children;

    var list = <Widget>[];
    // for (var i = 0; i < children.length; i++) {
    //   list.add(children[i]);
    //   list.add(spacing ?? SizedBox(height: 24.h));
    // }
    if(startSpacing != null) startSpacing;
    for (var item in children) {
      list.add(item);
      list.add(spacing ?? SizedBox(height: 24.h));
    }
    // list.remove(list.last);
    return list;
  }
}
