import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/login/view/login_page.dart';
import 'package:bioplus/ui/otp/otp/otp_screen.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/dialogs/mail_sent_dialog.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final Api authRepo;
  SignUpCubit(this.authRepo) : super(const SignUpState());

  void onEmailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void onCountryChanged(String value) {
    emit(state.copyWith(countryOfResidency: value));
  }

  void onPhoneChanged(String value, String countryCode) {
    emit(
      state.copyWith(
        phoneNumber: value,
        countryCode: countryCode,
      ),
    );
  }

  void onFirstNameChanged(String value) {
    emit(state.copyWith(firstName: value));
  }

  void onSurnameChanged(String value) {
    emit(state.copyWith(lastName: value));
  }

  void onPasswordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  void setTermsAndConditions(bool? value) {
    emit(state.copyWith(termsAndConditions: value ?? false));
  }

  Future<void> signUp() async {
    if (!state.termsAndConditions) {
      Get.snackbar('T&C Required', 'Please accept terms and conditions');
      return;
    }

    final model = SignUpModel(
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      phoneNumber: int.parse(state.phoneNumber),
      password: state.password,
      countryCode: state.countryCode,
      countryOfResidency: state.countryOfResidency
    );
    final result = await authRepo.signUp(data: model);
    result.when(
      success: (data) {
        DialogService.showDialog(
          child: MailSentDialog(
            message: data.message!,
            onContinue: () async {
              Get.back();
              await Get.to(
                () => OtpScreen(
                  authRepo: authRepo,
                  data: model,
                ),
              );
            },
          ),
        );
      },
      failure: (error) {
        DialogService.failure(
          error: error,
          onCancel: () {
            Get.back();
            Get.off(() => const LoginPage());
          },
        );
      },
    );
  }
}
