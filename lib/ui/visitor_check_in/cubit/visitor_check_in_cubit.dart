import 'dart:io';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/api_constants.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'visitor_check_in_state.dart';

class VisitorCheckInCubit extends Cubit<VisitorCheckInState> {
  final Api api;
  VisitorCheckInCubit({required this.api}) : super(const VisitorCheckInState()) {
    // getUserForms();
    emit(state.copyWith(showQrCodeForAndroid: Platform.isAndroid));
    getQrCode();
  }

  void changePlatForm() {
    emit(state.copyWith(showQrCodeForAndroid: !state.showQrCodeForAndroid));
  }

  // String get getQrData => state.showQrCodeForAndroid ? ApiConstants.playStoreid : ApiConstants.appStoreid;
  String get getQrData =>
      'Appstore link: ${ApiConstants.appStoreid}\n\nOr \n\nPlaystore link: ${ApiConstants.playStoreid}';
  // String get platform => state.showQrCodeForAndroid ? 'Android' : 'iPhone';
  // String get buttonText => state.showQrCodeForAndroid ? 'iPhone' : 'Android';

  // Future<void> getUserForms() async {
  //   emit(state.copyWith(isLoading: true));
  //   final result = await api.getUserForms();
  //   result.when(
  //     success: (data) {
  //       emit(state.copyWith(formData: data));
  //     },
  //     failure: (e) => DialogService.failure(error: e),
  //   );
  //   emit(state.copyWith(isLoading: false));
  // }

  Future<void> getQrCode() async {
    final result = await api.getQrCode(getQrData);
    result.when(
      success: (data) {
        final qrCode = (data['data'] as String).split(',').last;
        emit(state.copyWith(qrCode: qrCode));
      },
      failure: (e) => DialogService.failure(error: e),
    );
  }

  String getPhoneNumber() {
    final userData = api.getUserData();
    return '${userData?.countryCode ?? ''} ${userData?.phoneNumber ?? ''}';
  }
}
