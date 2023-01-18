import 'package:api_repo/api_repo.dart';
import 'package:bioplus/features/drawer/cubit/my_drawer_controller.dart';
import 'package:bioplus/features/drawer/view/drawer_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    // return DrawerView();
    return ChangeNotifierProvider(
      create: (context) => DrawerCubit(context.read<Api>()),
      child: const DrawerView(),
    );
  }
}
