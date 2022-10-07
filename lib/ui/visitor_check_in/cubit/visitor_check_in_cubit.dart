import 'package:api_repo/api_repo.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'visitor_check_in_state.dart';

class VisitorCheckInCubit extends Cubit<VisitorCheckInState> {
  final Api api;
  VisitorCheckInCubit({required this.api}) : super(const VisitorCheckInState()) {
    getUserForms();
    getQrCode();
  }

  Future<void> getUserForms() async {
    emit(state.copyWith(isLoading: true));
    final result = await api.getUserForms();
    result.when(
      success: (data) {
        emit(state.copyWith(formData: data));
      },
      failure: (e) => DialogService.failure(error: e),
    );
    emit(state.copyWith(isLoading: false));
  }

  Future<void> getQrCode() async {
    final result = await api.getQrCode('App store link and playstore link is coming soon...');
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
