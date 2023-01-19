import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/forgot_password/cubit/forgot_password_state.dart';
import 'package:bioplus/ui/forgot_password/view/reset_password.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/dialogs/mail_sent_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepo authRepo;
  final String email;
  // final SignUpModel signUpModel;
  ForgotPasswordCubit(this.authRepo, this.email) : super(ForgotPasswordState(email: email));

  void onTimeout() {
    emit(state.copyWith(isLoading: false, showCountdown: false));
  }

  Future<void> verityOtp(String otp) async {
    emit(state.copyWith(isLoading: true, showCountdown: true));
    final model = OtpModel(email: email, otp: otp);
    final result = await authRepo.resetPassword(model: model);
    result.when(success: (data) => _onSuccess(data, otp), failure: _onFailure);
    emit(state.copyWith(isLoading: false, showCountdown: false));
  }

  Future<void> onRetry() async {
    emit(state.copyWith(showCountdown: true, isLoading: false));
    final result = await authRepo.forgotPassword(email: email);
    result.when(success: _onRetrySuccess, failure: _onRetryFailure);
    emit(state.copyWith(showCountdown: false, isLoading: false));
  }

  void _onFailure(e) {
    DialogService.failure(error: e);
  }

  void _onSuccess(ResponseModel data, String otp) {
    DialogService.showDialog(
      child: MailSentDialog(
        message: data.message ?? Strings.somethingWentWrong,
        onContinue: () async {
          Get.back();
          await Get.offAll(() => ResetPassword(otp: otp, email: email));
        },
      ),
    );
  }

  void _onRetrySuccess(data) {
    DialogService.showDialog(
      child: MailSentDialog(
        message: data.message!,
        onContinue: () async {
          Get.back();
        },
      ),
    );
  }

  void _onRetryFailure(NetworkExceptions error) {
    _onFailure(error);
  }
}
