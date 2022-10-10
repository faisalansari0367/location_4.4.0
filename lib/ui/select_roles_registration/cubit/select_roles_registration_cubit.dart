// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:background_location/features/drawer/view/drawer_page.dart';
import 'package:background_location/provider/base_model.dart';
import 'package:background_location/ui/select_roles_registration/cubit/select_roles_registration_state.dart';
import 'package:background_location/ui/select_roles_registration/models/select_role_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/dialogs/dialog_service.dart';

class RolesRegistrationCubit extends BaseModel {
  var state = SelectRolesRegistrationState(
    selectedRoles: {},
    rolesList: [],
  );

  RolesRegistrationCubit(BuildContext context) : super(context) {
    getRoles();
  }

  Future<void> updateRole() async {
    final selectedRoles = state.rolesList.where((e) => e.isSelected);
    if (selectedRoles.isEmpty) {
      DialogService.error('Please select at least one role');
      return;
    }
    final user = api.getUserData()!;
    user.allowedRoles = selectedRoles.map((e) => e.role).toList();
    final result = await api.updateUser(userData: user);
    result.when(
      success: (data) => Get.offAll(() => DrawerPage()),
      failure: (error) => DialogService.failure(error: error),
    );
  }

  void emit(SelectRolesRegistrationState state) {
    this.state = state;
    notifyListeners();
  }

  Future<void> getRoles() async {
    setLoading(true);
    try {
      // final result = await (baseState.isConnected ? apiService.getUserRoles() : localApi.getUserRoles());
      // apiService.userRolesStream.listen((event) {
      //   emit(state.copyWith(isLoading: false, roles: event));
      // });
      // result.listen((event) {
      //   emit(state.copyWith(isLoading: false, roles: event));
      // }, onError: (s) {
      //   DialogService.showDialog(child: ErrorDialog(message: s.toString(), onTap: Get.back));
      // });
      final result = await apiService.getUserRoles();
      setLoading(false);
      result.when(
        success: (data) => emit(state.copyWith(rolesList: data.map((e) => SelectRoleModel(role: e.role)).toList())),
        failure: (error) => DialogService.failure(error: error),
      );
    } catch (e) {
      setLoading(false);
    }
  }

  // void selectRole(Role role) {
  //   emit();
  // }
}
