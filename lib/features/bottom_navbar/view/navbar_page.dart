import 'package:bioplus/features/bottom_navbar/cubit/navbar_cubit.dart';
import 'package:bioplus/features/bottom_navbar/view/navbar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavbarPage extends StatelessWidget {
  const NavbarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavbarCubit(),
      child: const NavbarView(),
    );
  }
}
