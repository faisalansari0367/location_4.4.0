import 'package:api_repo/api_repo.dart';
import 'package:background_location/services/notifications/connectivity/connectivity_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bloc/bloc.dart';
import 'package:get/get.dart';

import '../../../services/notifications/push_notifications.dart';
import '../../../widgets/dialogs/dialog_service.dart';
import '../../role_details/view/role_details_page.dart';
import 'select_role_state.dart';

export 'select_role_state.dart';

// import 'select_role_state.g.dart';

class SelectRoleCubit extends Cubit<SelectRoleState> {
  final Api api;
  final LocalApi localApi;

  final PushNotificationService pushNotificationService;
  SelectRoleCubit(this.api, this.localApi, this.pushNotificationService)
      : super(SelectRoleState(
          user: api.getUser()!,
        ),) {
    // api.userRolesStream.listen((event) {
    //   emit(state.copyWith(isLoading: false, roles: event));
    // });

    final connectivity = MyConnectivity();
    apiService = api;
    connectivity.connectionStream.listen((event) {
      apiService = event ? api : localApi;
      emit(state.copyWith(isConnected: event));
    });
    getRoles();
    // api.userRolesStream.listen((event) {
    //   emit(state.copyWith(roles: event));
    // });
    // getUser();
  }

  late Api apiService;

  Future<void> updateRole(UserRoles userRole) async {
    // Get.to(() => RoleDetailsPage(role: role));
    // final user = state.user;
    final user = apiService.getUser()!;
    user.role = userRole.role;
    user.registerationToken = await pushNotificationService.getFCMtoken();
    final result = await apiService.updateMe(user: user);
    result.when(
      success: (data) => Get.to(() => RoleDetailsPage(userRole: userRole)),
      failure: (error) => DialogService.failure(error: error),
    );
  }

  Future<void> getRoles() async {
    emit(state.copyWith(isLoading: state.roles.isEmpty));
    try {
      await 200.milliseconds.delay();
      final result = await (state.isConnected ? apiService.getUserRoles() : localApi.getUserRoles());
      // apiService.userRolesStream.listen((event) {
      //   emit(state.copyWith(isLoading: false, roles: event));
      // });
      // result.listen((event) {
      //   emit(state.copyWith(isLoading: false, roles: event));
      // }, onError: (s) {
      //   DialogService.showDialog(child: ErrorDialog(message: s.toString(), onTap: Get.back));
      // });
      result.when(
        success: (data) => emit(state.copyWith(isLoading: false, roles: data)),
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
  void emit(SelectRoleState state) {
    if (isClosed) return;
    super.emit(state);
  }

  // @override
  // SelectRoleState? fromJson(Map<String, dynamic> json) {
  //   return SelectRoleState.fromJson(json);
  // }

  // @override
  // Map<String, dynamic>? toJson(SelectRoleState state) {
  //   return state.toJson();
  // }
}
