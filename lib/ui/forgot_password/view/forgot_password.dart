import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/constans.dart';
import 'package:bioplus/constants/strings.dart';
import 'package:bioplus/extensions/size_config.dart';
import 'package:bioplus/gen/assets.gen.dart';
import 'package:bioplus/ui/forgot_password/view/forgot_password_screen.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:bioplus/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../widgets/dialogs/mail_sent_dialog.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  // String email = '';

  @override
  void initState() {
    final email = context.read<Api>().getUser()?.email ?? '';
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.text = email;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
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
                  Assets.images.forgotPassword.path,
                  // width: 50.width,
                ),
              ),
              // Spacer(),
              Gap(5.height),
              Text(
                '${Strings.forgot}\n${Strings.password}?',
                style: context.textTheme.headline4?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Gap(2.height),
              Text(
                "Don't worry! it happens. Please enter the address associated with your account.",
                style: context.textTheme.subtitle2?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              Gap(4.height),
              EmailField(
                // onChanged: (p0) => email = p0,
                controller: controller,
              ),
              Gap(2.height),
              // PasswordField(),
              // Gap(2.height),
              MyElevatedButton(
                text: Strings.submit,
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    formKey.currentState?.save();
                    await sentOtp();
                  }
                },
              ),
              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sentOtp() async {
    final result = await context.read<Api>().forgotPassword(email: controller.text.trim());
    // success('data');
    result.when(success: success, failure: failure);
  }

  void failure(NetworkExceptions error) {
    DialogService.failure(error: error);
  }

  void success(ResponseModel data) {
    // Get.to(ForgotPasswordOtpScreen(email: controller.text));
    DialogService.showDialog(
      child: MailSentDialog(
        message: data.message ?? Strings.somethingWentWrong,
        onContinue: () => Get.to(ForgotPasswordOtpScreen(email: controller.text)),
      ),
    );
  }
}
