import 'package:bioplus/constants/index.dart';
import 'package:bioplus/gen/assets.gen.dart';
import 'package:bioplus/helpers/validator.dart';
import 'package:bioplus/ui/sign_up/cubit/sign_up_cubit.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:bioplus/widgets/pdf_viewer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              Center(
                child: Assets.icons.appIcon.image(
                  fit: BoxFit.cover,
                  // width: 100.width,
                ),
              ),
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
                onCountryChanged: cubit.onCountryChanged,
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
                      // child: Text(
                      //   'By signing up, you agree to our Terms of Service and Privacy Policy.',
                      //   style: context.textTheme.bodyText2,
                      // ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'By signing up, you agree to our ',
                              style: context.textTheme.bodyText2,
                            ),
                            TextSpan(
                              text: Strings.termsAndConditions,
                              recognizer: _onTap(
                                PdfViewer(
                                  title: Strings.termsAndConditions,
                                  path:
                                      'assets/terms_and_conditions/Terms  Conditions (EULA) - BioPlus mobile application 20112022.pdf',
                                ),
                              ),
                              style: context.textTheme.bodyText2?.copyWith(
                                color: context.theme.primaryColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: context.textTheme.bodyText2,
                            ),
                            TextSpan(
                              text: Strings.privacyPolicy,
                              recognizer: _onTap(
                                PdfViewer(
                                  path: 'assets/terms_and_conditions/privacy_policy.pdf',
                                  title: Strings.privacyPolicy,
                                ),
                              ),
                              style: context.textTheme.bodyText2?.copyWith(
                                color: context.theme.primaryColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: '.',
                              style: context.textTheme.bodyText2,
                            ),
                          ],
                        ),
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

  GestureRecognizer _onTap(Widget page) => TapGestureRecognizer()..onTap = () => Get.to(() => page);
}
