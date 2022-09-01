import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/navbar_cubit.dart';
import 'navbar_view.dart';

class NavbarPage extends StatelessWidget {
  const NavbarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavbarCubit(),
      child: const NavbarView(),
    );
  }
}
