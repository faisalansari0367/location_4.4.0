import 'package:background_location/constants/constans.dart';
import 'package:background_location/constants/strings.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/gen/assets.gen.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        padding: kPadding,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  Assets.images.forgotPassword.path,
                ),
              ),
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
              EmailField(),
              Gap(2.height),
              // PasswordField(),
              // Gap(2.height),
              MyElevatedButton(
                text: Strings.submit,
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    formKey.currentState?.save();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
