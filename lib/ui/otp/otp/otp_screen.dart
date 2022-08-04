import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/constans.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/ui/otp/otp/otp_countdown.dart';
import 'package:background_location/ui/otp/otp/otp_cubit.dart';
import 'package:background_location/ui/otp/otp/otp_state.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  final Api authRepo;
  final SignUpModel data;
  const OtpScreen({Key? key, required this.data, required this.authRepo}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late OtpCubit cubit;
  // final cubit = OtpCubit(widget.authRepo, );

  @override
  void initState() {
    cubit = OtpCubit(widget.authRepo, widget.data);
    // cubit.loadInitialData();
    super.initState();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: const Text('OTP'),
      ),
      body: BlocConsumer<OtpCubit, OtpState>(
        bloc: cubit,
        listener: (BuildContext context, OtpState state) {
          if (state.error != null) {
            // TODO your code here
          }
        },
        builder: (BuildContext context, OtpState state) {
          // if (state.isLoading) {
          //   return Center(child: CircularProgressIndicator());
          // }

          return buildBody(state);
        },
      ),
    );
  }

  Widget buildBody(OtpState state) {
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
                text: widget.data.email,
                style: context.textTheme.subtitle2?.copyWith(fontSize: 15.sp),
              ),
            ],
          ),
        ),
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
                  onCompleted: (v) {
                    cubit.verityOtp(v);
                    // model.submitOTP(v, widget.verificationCode);
                  },
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
                  )),
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
                  onRetry: () => cubit.onRetry(widget.authRepo, widget.data),
                  onTimeout: cubit.onTimeout,
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
