import 'package:bioplus/ui/admin/cubit/admin_cubit.dart';
import 'package:bioplus/ui/admin/view/admin_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit(),
      child: const AdminView(),
    );
  }
}
