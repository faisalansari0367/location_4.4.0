import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/login/view/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/index.dart';
import '../../../gen/assets.gen.dart';
import '../../../widgets/dialogs/dialog_service.dart';
import '../../../widgets/dialogs/mail_sent_dialog.dart';
import '../../../widgets/my_appbar.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  final String otp;
  const ResetPassword({Key? key, required this.email, required this.otp}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formKey = GlobalKey<FormState>();
  final password = TextEditingController();
  final cPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        // leading: Icon,
        onBackPressed: () => Get.offAll(() => const LoginPage()),
      ),
      body: SingleChildScrollView(
        padding: kPadding,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  Assets.images.resetPassword.path,
                ),
              ),
              // Spacer(),
              Gap(5.height),
              Text(
                '${Strings.reset}\n${Strings.password}?',
                style: context.textTheme.headline4?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Gap(2.height),
              Text(
                Strings.forgotPasswordMessage,
                style: context.textTheme.subtitle2?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              Gap(4.height),
              PasswordField(
                // onChanged: (p0) => email = p0,
                controller: password,
              ),
              Gap(1.height),

              PasswordField(
                // onChanged: (p0) => email = p0,
                controller: cPassword,
                hintText: Strings.confirmPassword,
              ),

              Gap(2.height),
              // PasswordField(),
              // Gap(2.height),
              MyElevatedButton(
                text: Strings.submit,
                onPressed: validate,
                // onPressed: () async {
                //   if (formKey.currentState?.validate() ?? false) {
                //     formKey.currentState?.save();
                //     Get.offAll(() => LoginPage());
                //     // sentOtp();
                //   }
                // },
              ),
              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> validate() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      if (password.text != cPassword.text) {
        Get.snackbar('Passwords Mismatch', 'Passwords did not match, Please try agian.');
      } else {
        await resetPassword();
      }
    }
  }

  Future<void> resetPassword() async {
    final authRepo = context.read<Api>();
    final model = OtpModel(email: widget.email, otp: widget.otp, password: password.text);
    final result = await authRepo.resetPassword(model: model);
    result.when(success: _onSuccess, failure: (error) => DialogService.failure(error: error));
  }

  void _onSuccess(ResponseModel data) {
    DialogService.showDialog(
      child: MailSentDialog(
        message: 'password changed successfully. Press continue to login',
        onContinue: () async {
          Get.back();
          await Get.offAll(() => const LoginPage());
        },
      ),
    );
  }
}
