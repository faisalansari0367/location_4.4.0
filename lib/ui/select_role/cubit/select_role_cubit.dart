import 'dart:ui';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/features/webview/flutter_webview.dart';
import 'package:bioplus/services/notifications/connectivity/connectivity_service.dart';
import 'package:bioplus/services/notifications/push_notifications.dart';
import 'package:bioplus/ui/role_details/view/role_details_page.dart';
import 'package:bioplus/ui/select_role/cubit/select_role_state.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bloc/bloc.dart';
import 'package:get/get.dart';

export 'select_role_state.dart';

// import 'select_role_state.g.dart';

class SelectRoleCubit extends Cubit<SelectRoleState> {
  final Api api;
  final LocalApi localApi;
  final VoidCallback? onRoleUpdated;
  final PushNotificationService pushNotificationService;
  SelectRoleCubit(
    this.api,
    this.localApi,
    this.pushNotificationService, {
    this.onRoleUpdated,
  }) : super(
          SelectRoleState(
            user: api.getUser() ?? const User(),
          ),
        ) {
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

    // final user = apiService.getUser()!;

    Get.to(() => RoleDetailsPage(userRole: userRole));
    return;
    // if (user.role == 'Admin') {
    //   return;
    // }

    // // user.role = userRole.role;
    // final updateUser = user.copyWith(
    //   role: userRole.role,
    //   registerationToken: await pushNotificationService.getFCMtoken(),
    // );
    // // user.registerationToken = await pushNotificationService.getFCMtoken();
    // final result = await apiService.updateMe(user: updateUser);
    // result.when(
    //   success: (data) => Get.to(() => RoleDetailsPage(userRole: userRole)),
    //   failure: (error) => DialogService.failure(error: error),
    // );
  }

  Future<void> createPortal() async {
    final result = await api.createPortal();
    result.when(
      success: (data) => Get.to(() => Webview(url: data)),
      failure: (error) => DialogService.failure(error: error),
    );
  }

  Future<void> getRoles() async {
    emit(state.copyWith(isLoading: state.roles.isEmpty));
    try {
      await 200.milliseconds.delay();
      final result = await (state.isConnected
          ? apiService.getUserRoles()
          : localApi.getUserRoles());
      // apiService.userRolesStream.listen((event) {
      //   emit(state.copyWith(isLoading: false, roles: event));
      // });
      // result.listen((event) {
      //   emit(state.copyWith(isLoading: false, roles: event));
      // }, onError: (s) {
      //   DialogService.showDialog(child: ErrorDialog(message: s.toString(), onTap: Get.back));
      // });
      result.when(
        success: _onSuccess,
        failure: (error) {
          emit(state.copyWith(isLoading: false));
          DialogService.failure(error: error);
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onSuccess(List<UserRoles> data) {
    // final userData = api.getUserData();
    // final allowedRoles = userData?.allowedRoles ?? [];
    // final roles = data.where((element) => allowedRoles.contains(element.role)).map((e) => e.role).toList();
    // roles.add('International Traveller');
    emit(
      state.copyWith(
        isLoading: false,
        roles: data,
      ),
    );
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
