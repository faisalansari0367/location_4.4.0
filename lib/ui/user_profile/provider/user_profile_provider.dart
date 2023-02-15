import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/ui/envd/cubit/graphql_client.dart';
import 'package:bioplus/ui/login/view/login_page.dart';
import 'package:bioplus/ui/maps/location_service/geofence_service.dart';
import 'package:bioplus/widgets/dialogs/delete_dialog.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileNotifier extends BaseModel {
  UserProfileNotifier(super.context) {
    user = apiService.getUserData() ?? UserData();
  }

  // UserData? get userData => apiService.getUserData();

  UserData user = UserData();

  void onFirstNameChanged(String value) => user.firstName = value;
  void onLastNameChanged(String value) => user.lastName = value;
  void onEmailChanged(String value) => user.email = value;
  void onEmergencyEmailChanged(String value) =>
      user.emergencyEmailContact = value;
  void onPhoneNumberChanged(String value) => user.phoneNumber = value;
  // void onAddressChanged(String value) => user.address = value;
  void onCityChanged(String value) => user.city = value;
  // void onCountryChanged(String value) => user.countr = value;
  void onStateChanged(String value) => user.state = value;
  void onPostCodeChanged(String value) => user.postcode = int.tryParse(value);

  void onEmergencyMobileContactChanged(String value) =>
      user.emergencyMobileContact = value;

  void onCompanyChanged(String? value) {
    if (value == null) return;
    user.company = [value];
    notifyListeners();
  }

  bool get showGeofenceDelegation => [
        Roles.producer.name,
        Roles.processor.name,
        Roles.agent.name,
        Roles.feedlotter.name,
        Roles.admin.name,
      ].contains(user.role?.toLowerCase());

  Future<void> updateUser() async {
    final result = await apiService.updateUserData(
      data: UserData(
        firstName: user.firstName,
        lastName: user.lastName,
        emergencyEmailContact: user.emergencyEmailContact,
        phoneNumber: user.phoneNumber,
        emergencyMobileContact: user.emergencyMobileContact,
        city: user.city,
        state: user.state,
        postcode: user.postcode,
      ),
    );
    result.when(
      success: (data) {
        DialogService.success(
          'User updated successfully',
          onCancel: () => Get.close(2),
        );
      },
      failure: (error) => DialogService.failure(error: error),
    );
  }

  Future<void> logout(BuildContext context) async {
    geofenceRepo.cancel();
    context.read<GeofenceService>().cancel();
    final client = GraphQlClient(username: '', password: '');
    await client.clearStorage();
    await api.logout();
    await Get.offAll(() => const LoginPage());
  }

  Future<void> deleteAccount(BuildContext context) async {
    await DialogService.showDialog(
      child: DeleteDialog(
        msg: 'Are you sure you want to DELETE your account?',
        onCancel: () {},
        onConfirm: () async {
          final deleteUser = await api.deleteUser();
          deleteUser.when(
            success: (s) async {
              DialogService.success(
                s,
                onCancel: () async {
                  await logout(context);
                  Get.back();
                },
              );
            },
            failure: (error) => DialogService.failure(error: error),
          );
        },
      ),
    );
  }
}
