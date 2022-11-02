import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/constans.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/ui/forgot_password/cubit/forgot_password_state.dart';
import 'package:background_location/ui/otp/otp/otp_countdown.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../cubit/forgot_password_cubit.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  // final ForgotPasswordCubit cubit;
  // final Api authRepo;
  // final SignUpModel data;
  final String email;
  const ForgotPasswordOtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ForgotPasswordOtpScreenState createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  late ForgotPasswordCubit cubit;
  // final cubit = OtpCubit(widget.authRepo, );

  @override
  void initState() {
    cubit = ForgotPasswordCubit(context.read<Api>(), widget.email);
    // cubit.loadInitialData();
    super.initState();
  }

  @override
  void dispose() {
    // cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
          // title: const Text('OTP'),
          ),
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        bloc: cubit,
        listener: (BuildContext context, ForgotPasswordState state) {
          if (state.error != null) {
          }
        },
        builder: (BuildContext context, ForgotPasswordState state) {
          // if (state.isLoading) {
          //   return Center(child: CircularProgressIndicator());
          // }

          return buildBody(state);
        },
      ),
    );
  }

  Widget buildBody(ForgotPasswordState state) {
    return ListView(
      padding: kPadding,
      children: [
        Text(
          'Verify your otp',
          style: context.textTheme.headline5,
        ),
        Gap(1.height),
        RichText(
          text: TextSpan(
            text: 'Enter the otp sent to ',
            style: context.textTheme.subtitle1,
            children: [
              TextSpan(
                text: state.email,
                style: context.textTheme.subtitle2?.copyWith(fontSize: 15.sp),
              ),
            ],
          ),
        ),
        Gap(2.height),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info, color: context.theme.errorColor.withOpacity(0.7)),
            Gap(2.width),
            Expanded(
              child: Text(
                'If you do not see the email in a few minutes, check your “junk mail” folder or “spam” folder.',
                style: TextStyle(
                  color: context.theme.errorColor.withOpacity(0.8),
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        Gap(2.height),

        SizedBox(
          width: 70.width,
          height: 10.height,
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: PinCodeTextField(
                  // controller: otpController.textFieldController,
                  autoFocus: true,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  length: 6,
                  cursorColor: context.theme.primaryColor,
                  pinTheme: PinTheme(
                    activeColor: Colors.grey,
                    shape: PinCodeFieldShape.underline,
                    borderWidth: 2,
                    fieldHeight: 50,
                    fieldWidth: 40,
                    selectedColor: context.theme.primaryColor,
                    inactiveColor: Colors.black26,
                    disabledColor: Colors.black26,
                  ),
                  backgroundColor: Colors.transparent,
                  onCompleted: cubit.verityOtp,
                  onChanged: (value) {},
                  beforeTextPaste: (text) {
                    return true;
                  },
                  appContext: context,
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox.expand(
                  child: Center(
                      child: SizedBox.square(
                    dimension: 5.width,
                    child: state.isLoading
                        ? CircularProgressIndicator(
                            strokeWidth: 3.w,
                          )
                        : null,
                  ),),
                ),
              )
            ],
          ),
        ),
        // if (!state.isLoading)
        AnimatedSwitcher(
          duration: kDuration,
          child: !state.isLoading
              ? OtpCountDown(
                  showCountdown: state.showCountdown,
                  onRetry: cubit.onRetry,
                  onTimeout: cubit.onTimeout,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
