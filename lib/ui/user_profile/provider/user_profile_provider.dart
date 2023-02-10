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
  UserProfileNotifier(super.context);

  UserData? get user => apiService.getUserData();

  UserData userData = UserData();

  void onFirstNameChanged(String value) => userData.firstName = value;
  void onLastNameChanged(String value) => userData.lastName = value;
  void onEmailChanged(String value) => userData.email = value;
  void onEmergencyEmailChanged(String value) =>
      userData.emergencyEmailContact = value;
  void onPhoneNumberChanged(String value) => userData.phoneNumber = value;
  // void onAddressChanged(String value) => userData.address = value;
  void onCityChanged(String value) => userData.city = value;
  // void onCountryChanged(String value) => userData.countr = value;
  void onStateChanged(String value) => userData.state = value;
  void onPostCodeChanged(String value) =>
      userData.postcode = int.tryParse(value);

  bool get showGeofenceDelegation => [
        Roles.producer.name,
        Roles.processor.name,
        Roles.agent.name,
        Roles.feedlotter.name,
        Roles.admin.name,
      ].contains(user?.role?.toLowerCase());

  Future<void> updateUser() async {
    final result = await apiService.updateUser(userData: userData);
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
    final client = GraphQlClient();
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
