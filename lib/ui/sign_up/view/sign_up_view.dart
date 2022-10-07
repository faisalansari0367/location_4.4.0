import 'package:background_location/constants/index.dart';
import 'package:background_location/gen/assets.gen.dart';
import 'package:background_location/helpers/validator.dart';
import 'package:background_location/ui/sign_up/cubit/sign_up_cubit.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final cubit = context.read<SignUpCubit>();
    final gap = Gap(0.5.height);

    return Scaffold(
      appBar: const MyAppBar(),
      body: SingleChildScrollView(
        padding: kPadding,
        child: Form(
          key: key,
          child: Column(
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
                inputFormatters: const [],
                hintText: Strings.firstName,
                validator: Validator.text,
                onChanged: cubit.onFirstNameChanged,
              ),
              gap,
              MyTextField(
                inputFormatters: const [],
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
              Gap(1.height),
              InkWell(
                onTap: () => cubit.setTermsAndConditions(!cubit.state.termsAndConditions),
                child: Row(
                  children: [
                    BlocBuilder<SignUpCubit, SignUpState>(
                      builder: (context, state) {
                        return Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          value: state.termsAndConditions,
                          onChanged: cubit.setTermsAndConditions,
                        );
                      },
                    ),
                    Expanded(
                      child: Text(
                        // 'I Agree to accept Terms And Conditions',
                        Strings.privacyPolicyMessage,

                        style: context.textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
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
