import 'package:api_repo/api_repo.dart';
import 'package:bioplus/features/drawer/view/drawer_page.dart';
import 'package:bioplus/ui/maps/view/maps_page.dart';
import 'package:bioplus/ui/otp/otp/otp_state.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/dialogs/mail_sent_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class OtpCubit extends Cubit<OtpState> {
  final AuthRepo authRepo;
  final SignUpModel signUpModel;
  OtpCubit(this.authRepo, this.signUpModel) : super(const OtpState());

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
          Get.offAll(() => const DrawerPage());

          

          Get.to(() => const MapsPage());
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
