import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:background_location/ui/otp/otp/otp_state.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../widgets/dialogs/mail_sent_dialog.dart';
import '../../select_role/view/select_role_page.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthRepo authRepo;
  final SignUpModel signUpModel;
  OtpCubit(this.authRepo, this.signUpModel) : super(OtpState());

  void onTimeout() {
    emit(state.copyWith(isLoading: false, showCountdown: false));
  }

  Future<void> verityOtp(String otp) async {
    emit(state.copyWith(isLoading: true, showCountdown: true));
    final model = OtpModel(email: signUpModel.email!, otp: otp);
    final result = await authRepo.verifyOtp(otpModel: model);
    result.when(success: _onSuccess, failure: _onFailure);
    emit(state.copyWith(isLoading: false, showCountdown: false));
  }

  Future<void> onRetry(AuthRepo repo, SignUpModel data) async {
    emit(state.copyWith(showCountdown: true, isLoading: false));
    final result = await repo.signUp(data: data);
    result.when(success: _onRetrySuccess, failure: _onRetryFailure);
    emit(state.copyWith(showCountdown: false, isLoading: false));
  }

  void _onFailure(e) {
    DialogService.failure(error: e);
  }

  void _onSuccess(data) {
    DialogService.showDialog(
      child: MailSentDialog(
        message: 'Otp verified successfully',
        onContinue: () async {
          Get.back();
          await Get.offAll(() => SelectRolePage());
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
