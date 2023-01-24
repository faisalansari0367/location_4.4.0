// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_repo.dart';
import 'package:bioplus/features/drawer/view/drawer_page.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/ui/maps/view/maps_page.dart';
import 'package:bioplus/ui/select_role/payment_sheet/view/payment_sheet_page.dart';
import 'package:bioplus/ui/select_roles_registration/cubit/select_roles_registration_state.dart';
import 'package:bioplus/ui/select_roles_registration/models/select_role_model.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RolesRegistrationCubit extends BaseModel {
  final bool isFromRegistration;
  final VoidCallback? onRoleUpdated;
  SelectRolesRegistrationState state = SelectRolesRegistrationState(
    rolesList: [],
  );

  RolesRegistrationCubit(
    super.context, {
    this.isFromRegistration = true,
    this.onRoleUpdated,
  }) {
    getRoles();
  }

  Future<void> buyServiceRole(SelectRoleModel role) async {
    await Get.to(() => PaymentSheetPage(role: role.role));
    onRoleUpdated?.call();
  }

  Future<void> updateRole() async {
    try {
      final selectedRoles = state.rolesList.where((e) => e.isSelected);
      if (selectedRoles.isEmpty) {
        // DialogService.error('Please select at least one role');
        // return;
        Get.offAll(() => const DrawerPage());
        Get.to(() => const MapsPage());
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
          // Get.to(() => PaymentSheetPage(role: user.role!));
        },
        failure: (error) => DialogService.failure(error: error),
      );
    } catch (e) {
      print(e);
    }
  }

  void _onRoleUpdated() {
    Get.offAll(() => const DrawerPage());
    if (isFromRegistration) Get.to(() => const MapsPage());
  }

  void emit(SelectRolesRegistrationState state) {
    this.state = state;
    notifyListeners();
  }

  final List<String> freeRoles = [
    'Visitor',
    'Employee',
    'International Traveller',
    'Transporter',
  ];

  Future<void> getRoles() async {
    setLoading(true);
    try {
      final result = await apiService.getRoles();
      setLoading(false);
      result.when(
        success: (data) {
          final roles = data.data..remove('Visitor');
          final userData = api.getUserData();
          final allowedRoles = userData?.allowedRoles ?? [];
          emit(
            state.copyWith(
              rolesList: roles
                  .map(
                    (e) => SelectRoleModel(
                      role: e,
                      isSelected: allowedRoles.contains(e) || e == 'Visitor',
                      isPaidRole: !freeRoles.contains(e),
                      isSubscribed: allowedRoles.contains(e),
                    ),
                  )
                  .toList(),
            ),
          );
          // _fillRoles();
        },
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
