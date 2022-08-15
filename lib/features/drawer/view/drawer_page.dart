import 'package:flutter/material.dart';

import 'drawer_view.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerView();
    // return ChangeNotifierProvider(
    //   create: (context) => DrawerCubit(),
    //   child: DrawerView(),
    // );
  }
}
