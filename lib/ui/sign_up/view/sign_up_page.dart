import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/sign_up/view/sign_up_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/sign_up_cubit.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(context.read<Api>()),
      child: const SignUpView(),
    );
  }
}
