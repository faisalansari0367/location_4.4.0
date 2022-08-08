import 'package:api_repo/api_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

import '../../../widgets/dialogs/dialog_service.dart';

part 'select_role_state.dart';

class SelectRoleCubit extends Cubit<SelectRoleState> {
  final Api api;
  SelectRoleCubit(this.api) : super(SelectRoleState()) {
    getRoles();
    getUser();
  }

  void getUser() {
    final result = api.getUser();
    emit(state.copyWith(userName: (result?.firstName?.capitalize) ?? ''));
  }

  Future<void> getRoles() async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await api.getUserRoles();
      result.when(
        success: (data) => emit(state.copyWith(isLoading: false, roles: data.roles)),
        failure: (error) {
          emit(state.copyWith(isLoading: false));
          DialogService.failure(error: error);
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

}
