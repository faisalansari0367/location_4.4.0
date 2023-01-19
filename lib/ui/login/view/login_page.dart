import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/login/cubit/login_cubit.dart';
import 'package:bioplus/ui/login/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  final String? email;
  const LoginPage({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        localApi: context.read<LocalApi>(),
        repository: context.read<Api>(),
        email: email,
      ),
      child: const LoginView(),
    );
  }
}
