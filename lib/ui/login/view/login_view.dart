import 'package:background_location/constants/constans.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/ui/forgot_password/view/forgot_password.dart';
import 'package:background_location/ui/sign_up/view/sign_up_page.dart';
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
      appBar: MyAppBar(
        showBackButton: false,
        leading: SizedBox(),
      ),
      body: Padding(
        padding: kPadding,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    Assets.images.login.path,
                  ),
                ),
                Text(
                  Strings.login,
                  style: context.textTheme.headline4?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.height),
                EmailField(
                  controller: cubit.emailController,
                  onChanged: cubit.onChangedEmail,
                ),
                SizedBox(height: 2.height),
                PasswordField(onChanged: cubit.onChangedPassword, onSubmitted: (s) => onLogin()),
                Gap(1.height),
                GestureDetector(
                  onTap: () => Get.to(() => ForgotPassword()),
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
                MyElevatedButton(
                  onPressed: onLogin,
                  text: Strings.login,
                ),

                Gap(5.height),
                Align(
                  child: TextButton(
                    onPressed: () => Get.to(() => SignUpPage()),
                    child: Text(
                      '${Strings.newToItrack} ${Strings.register}',
                      // style: context.textTheme.bodyText2.copy,
                    ),
                    style: TextButton.styleFrom(
                      textStyle: context.textTheme.bodyText2?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // New to Itrack ? Register
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       Strings.newToItrack,
                //       style: context.textTheme.subtitle2?.copyWith(
                //           // color: context.theme.primaryColor,s
                //           ),
                //     ),
                //     SizedBox(width: 10.w),
                //     GestureDetector(
                //       onTap: () => Get.to(SignUpPage()),
                //       child: Text(
                //         Strings.register,
                //         style: context.textTheme.subtitle2?.copyWith(
                //           color: context.theme.primaryColor,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

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
