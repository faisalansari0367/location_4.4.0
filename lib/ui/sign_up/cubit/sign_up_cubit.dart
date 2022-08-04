import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/otp/otp/otp_screen.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:background_location/widgets/dialogs/mail_sent_dialog.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final Api authRepo;
  SignUpCubit(this.authRepo) : super(SignUpState());

  void onEmailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void onPhoneChanged(String value) {
    emit(state.copyWith(phoneNumber: value));
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

  Future<void> signUp() async {
    
    final model = SignUpModel(
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      phoneNumber: int.parse(state.phoneNumber),
      password: state.password,
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
      failure: (error) => DialogService.failure(error: error),
    );
  }
}
