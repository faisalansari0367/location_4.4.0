import 'package:bioplus/constants/constans.dart';
import 'package:bioplus/extensions/size_config.dart';
import 'package:bioplus/ui/forgot_password/view/forgot_password.dart';
import 'package:bioplus/ui/sign_up/view/sign_up_page.dart';
import 'package:bioplus/widgets/logo/app_name_widget.dart';
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
      // appBar: const MyAppBar(
      //   showBackButton: false,
      //   // title: Text('Login'),
      //   leading: SizedBox.shrink(),
      // ),
      body: Padding(
        padding: kPadding.copyWith(top: 0),
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Spacer(),
                    Gap(7.height),
                    AnimatedContainer(
                      duration: 500.milliseconds,
                      curve: Curves.ease,
                      child: Center(
                        // heightFactor: 1.5,
                        child: Image.asset(
                          Assets.icons.appIcon.path,
                          fit: BoxFit.cover,
                          height: constraints.maxHeight / 3,
                        ),
                      ),
                    ),
                    Center(
                      child: AppName(
                        fontSize: constraints.maxHeight / 15,
                      ),
                    ),
                    Gap(2.height),

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
                    PasswordField(onChanged: cubit.onChangedPassword, onSubmitted: (s) => onLogin()),
                    Gap(1.height),
                    GestureDetector(
                      onTap: () => Get.to(() => const ForgotPassword()),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${Strings.forgotPassword}?',
                          style: context.textTheme.subtitle2?.copyWith(
                            color: context.theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.height),
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        return MyElevatedButton(
                          onPressed: onLogin,
                          isLoading: state.isLoading,
                          // isLoading: ,
                          text: Strings.login,
                        );
                      },
                    ),

                    Gap(1.height),
                    Align(
                      child: TextButton(
                        onPressed: () => Get.to(() => const SignUpPage()),
                        style: TextButton.styleFrom(
                          textStyle: context.textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: Text(
                          '${Strings.newToItrack} ${Strings.register}',
                          // style: context.textTheme.bodyText2.copy,
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
              );
            },
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
