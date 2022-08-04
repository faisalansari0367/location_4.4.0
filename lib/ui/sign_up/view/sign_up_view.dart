import 'package:background_location/constants/constans.dart';
import 'package:background_location/constants/strings.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/gen/assets.gen.dart';
import 'package:background_location/helpers/validator.dart';
import 'package:background_location/ui/sign_up/cubit/sign_up_cubit.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/text_fields/phone_text_field.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final cubit = context.read<SignUpCubit>();
    final gap = Gap(0.5.height);

    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        padding: kPadding,
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Assets.images.signup.image(),
              Text(
                Strings.signUp,
                style: context.textTheme.headline4?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3.height),
              MyTextField(
                hintText: Strings.firstName,
                validator: Validator.text,
                onChanged: cubit.onFirstNameChanged,
              ),
              gap,
              MyTextField(
                hintText: Strings.surname,
                validator: Validator.text,
                onChanged: cubit.onSurnameChanged,
              ),
              gap,
              PhoneTextField(
                onChanged: cubit.onPhoneChanged,
              ),
              gap,
              EmailField(
                onChanged: cubit.onEmailChanged,
              ),
              gap,
              PasswordField(
                onChanged: cubit.onPasswordChanged,
              ),
              Gap(3.height),
              MyElevatedButton(
                text: Strings.submit,
                onPressed: () async {
                  final isValidated = key.currentState?.validate();
                  if (isValidated ?? false) {
                    await cubit.signUp();
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
