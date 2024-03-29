import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/admin/pages/users_list/cubit/users_cubit.dart';
import 'package:bioplus/ui/admin/pages/users_list/view/users_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersCubit(context.read<Api>()),
      child: const UsersView(),
    );
  }
}
