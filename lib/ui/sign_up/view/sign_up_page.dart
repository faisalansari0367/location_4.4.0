import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/sign_up/cubit/sign_up_cubit.dart';
import 'package:bioplus/ui/sign_up/view/sign_up_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(context.read<Api>()),
      child: const SignUpView(),
    );
  }
}
