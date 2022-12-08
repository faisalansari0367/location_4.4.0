// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_repo.dart';
import 'package:bioplus/features/drawer/view/drawer_page.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/ui/maps/view/maps_page.dart';
import 'package:bioplus/ui/select_roles_registration/cubit/select_roles_registration_state.dart';
import 'package:bioplus/ui/select_roles_registration/models/select_role_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/dialogs/dialog_service.dart';

class RolesRegistrationCubit extends BaseModel {
  final bool isFromRegistration;
  final VoidCallback? onRoleUpdated;
  var state = SelectRolesRegistrationState(
    rolesList: [],
  );

  RolesRegistrationCubit(BuildContext context, {this.isFromRegistration = true, this.onRoleUpdated}) : super(context) {
    getRoles();
  }

  Future<void> updateRole() async {
    try {
      final selectedRoles = state.rolesList.where((e) => e.isSelected);
      if (selectedRoles.isEmpty) {
        // DialogService.error('Please select at least one role');
        // return;
        Get.offAll(() => DrawerPage());
        Get.to(() => MapsPage());
      }
      final user = api.getUserData() ?? UserData();

      user.allowedRoles = selectedRoles.map((e) => e.role).toList();
      final result = await api.updateUser(userData: user);
      result.when(
        success: (data) {
          if (onRoleUpdated != null) {
            onRoleUpdated?.call();
          } else {
            _onRoleUpdated();
          }
          // onRoleUpdated?.call() ??  _onRoleUpdated;
        },
        failure: (error) => DialogService.failure(error: error),
      );
    } catch (e) {
      print(e);
    }
  }

  void _onRoleUpdated() {
    Get.offAll(() => DrawerPage());
    if (isFromRegistration) Get.to(() => MapsPage());
  }

  void emit(SelectRolesRegistrationState state) {
    this.state = state;
    notifyListeners();
  }

  Future<void> getRoles() async {
    setLoading(true);
    try {
      final result = await apiService.getRoles();
      setLoading(false);
      result.when(
        success: (data) {
          final roles = data.data..remove('Visitor');
          emit(
            state.copyWith(
              rolesList: roles.map((e) => SelectRoleModel(role: e, isSelected: e == 'Visitor')).toList(),
            ),
          );
          _fillRoles();
        },
        failure: (error) => DialogService.failure(error: error),
      );
    } catch (e) {
      setLoading(false);
    }
  }

  void _fillRoles() {
    final userData = api.getUserData();
    final _allowedRoles = userData?.allowedRoles ?? [];
    if (_allowedRoles.isEmpty) return;
    for (final role in state.rolesList) {
      final roleIsSelected = _allowedRoles.contains(role.role);
      if (roleIsSelected) {
        role.isSelected = true;
      }
    }
    notifyListeners();
  }

  // void selectRole(Role role) {
  //   emit();
  // }
}
