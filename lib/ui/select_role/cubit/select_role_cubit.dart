import 'package:api_repo/api_repo.dart';
// import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../widgets/dialogs/dialog_service.dart';
import '../../role_details/view/role_details_page.dart';
import 'select_role_state.dart';

export 'select_role_state.dart';

// import 'select_role_state.g.dart';

class SelectRoleCubit extends Cubit<SelectRoleState> {
  final Api api;
  SelectRoleCubit(this.api)
      : super(SelectRoleState(
          user: api.getUser()!,
        )) {
    getRoles();
    // getUser();
  }

  Future<void> updateRole(String role) async {
    // Get.to(() => RoleDetailsPage(role: role));
    final user = state.user;
    user.role = role;
    final result = await api.updateUser(user: user);
    result.when(
      success: (data) => Get.to(() => RoleDetailsPage(role: role)),
      failure: (error) => DialogService.failure(error: error),
    );
  }

  Future<void> getRoles() async {
    emit(state.copyWith(isLoading: state.roles.isEmpty));
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

  @override
  SelectRoleState? fromJson(Map<String, dynamic> json) {
    return SelectRoleState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SelectRoleState state) {
    return state.toJson();
  }
}
