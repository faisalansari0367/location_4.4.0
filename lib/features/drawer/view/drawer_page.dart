import 'package:api_repo/api_repo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cubit/my_drawer_controller.dart';
import 'drawer_view.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return DrawerView();
    return ChangeNotifierProvider(
      create: (context) => DrawerCubit(context.read<Api>()),
      child: DrawerView(),
    );
  }
}
