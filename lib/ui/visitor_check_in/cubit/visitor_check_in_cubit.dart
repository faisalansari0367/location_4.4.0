import 'package:api_repo/api_repo.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'visitor_check_in_state.dart';

class VisitorCheckInCubit extends Cubit<VisitorCheckInState> {
  final Api api;
  VisitorCheckInCubit({required this.api}) : super(VisitorCheckInState()) {
    getUserForms();
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
}
