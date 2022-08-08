import 'package:api_repo/api_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/login_cubit.dart';
import 'login_view.dart';

class LoginPage extends StatelessWidget {
  final String? email;
  const LoginPage({Key? key, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(repository: context.read<Api>(), email: email),
      child: const LoginView(),
    );
  }
}
