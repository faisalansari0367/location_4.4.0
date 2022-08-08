import 'package:background_location/constants/constans.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/ui/forgot_password/view/forgot_password.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../constants/strings.dart';
import '../../../gen/assets.gen.dart';
import '../../../widgets/widgets.dart';
import '../cubit/login_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return Scaffold(
      appBar: MyAppBar(),
      body: Padding(
        padding: kPadding,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  Assets.images.login.path,
                  height: 40.height,
                ),
                Text(
                  Strings.login,
                  style: context.textTheme.headline4?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2.height),
                EmailField(
                  controller: cubit.emailController,
                  onChanged: cubit.onChangedEmail,
                ),
                SizedBox(height: 2.height),
                PasswordField(
                  onChanged: cubit.onChangedPassword,
                ),
                Gap(1.height),
                GestureDetector(
                  onTap: () => Get.to(ForgotPassword()),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      Strings.forgotPassword + '?',
                      style: context.textTheme.subtitle2?.copyWith(
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.height),
                BlocListener<LoginCubit, LoginState>(
                  listenWhen: (previous, current) => previous.error != current.error,
                  listener: (context, state) {
                    print(state.error);
                    if (state.error.isEmpty) return;
                    ScaffoldMessenger.maybeOf(context)
                      ?..removeCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          backgroundColor: context.theme.colorScheme.secondary.withAlpha(50),
                          content: Text(
                            state.error,
                            style: context.textTheme.bodyText2?.copyWith(
                              color: const Color.fromARGB(255, 233, 83, 72),
                            ),
                          ),
                        ),
                      );
                    cubit.clearError();
                  },
                  child: MyElevatedButton(
                    onPressed: onLogin,
                    text: (Strings.login),
                  ),
                ),
                SizedBox(height: 1.height),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      await context.read<LoginCubit>().onPressedLogin();
    }
  }
}
