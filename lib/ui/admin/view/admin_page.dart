import 'package:background_location/ui/admin/cubit/admin_cubit.dart';
import 'package:background_location/ui/admin/view/admin_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCubit(),
      child: AdminView(),
    );
  }
}
