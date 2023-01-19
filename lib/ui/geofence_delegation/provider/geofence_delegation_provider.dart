import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/ui/geofence_delegation/provider/geofence_delegation_state.dart';
import 'package:bioplus/widgets/dialogs/dialogs.dart';
import 'package:flutter/material.dart';

class GeofenceDelegationNotifier extends BaseModel {
  UserData? _userData;
  GeofenceDelegationNotifier(super.context) {
    _userData = apiService.getUserData();
  }

  GeofenceDelegationState _state = GeofenceDelegationState(
    startDate: DateTime.now(),
  );
  GeofenceDelegationState get state => _state;

  final formKey = GlobalKey<FormState>();

  String get temporaryOwnerEmail => _userData?.temporaryOwner ?? '';
  bool get isTemporaryOwner => _userData?.isTemporaryOwner ?? false;
  String get delegationStartDate => MyDecoration.formatDate(_userData?.delegationStartDate);
  String get delegationEndDate => MyDecoration.formatDate(_userData?.delegationEndDate);

  void emit(GeofenceDelegationState state) {
    _state = state;
    notifyListeners();
  }

  void setEmail(String? value) {
    emit(state.copyWith(email: value));
  }

  void setStartDate(String? value) {
    if (value == null) return;
    final dt = DateTime.parse(value);
    emit(state.copyWith(startDate: dt));
  }

  void setEndDate(String? value) {
    if (value == null) return;
    final dt = DateTime.parse(value);
    emit(state.copyWith(endDate: dt));
    // endDate = dt;
    // notifyListeners();
  }

  String? startDateValidator() {
    // print(state.startDate.day);
    final now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    // print(DateTime.now().day);
    final after = state.startDate.isAfter(now);
    final before = state.startDate.isBefore(now);
    final isEqual = state.startDate.isAtSameMomentAs(now);
    if (!(after || isEqual)) {
      return 'Start date must be greater than today';
    } else if (before) {
      return 'Start date can not be less than today';
    }

    return null;
  }

  String? endDateValidator(String? value) {
    if (value == null || value.isEmpty) return 'End date is required';
    final isBeforeStartDate = state.endDate?.isBefore(state.startDate) ?? false;
    final isSameAsStartDate = state.endDate?.isAtSameMomentAs(state.startDate) ?? false;
    if (isBeforeStartDate) {
      return 'End date must be greater than start date';
    } else if (isSameAsStartDate) {
      return 'End date must be greater than start date';
    }

    return null;
  }

  Future<void> updateMe() async {
    await apiService.updateMe(user: User(), isUpdate: false);
    _userData = apiService.getUserData();
    notifyListeners();
  }

  Future<void> delegateGeofence() async {
    try {
      if (!formKey.currentState!.validate()) return;

      final myFences = apiService.polygons.where((element) => element.createdBy?.id == _userData?.id);
      if (myFences.isEmpty) {
        DialogService.error('You have not created any geofences to delegate.');
      } else {
        setLoading(true);
        final TemporaryOwnerParams params = TemporaryOwnerParams(
          email: state.email,
          delegationStartDate: state.startDate,
          delegationEndDate: state.endDate!,
        );
        final result = await api.temporaryOwner(params);
        result.when(
          success: (data) {
            DialogService.success('Success', onCancel: Get.back);
            updateMe();
          },
          failure: (error) {
            DialogService.failure(error: error);
          },
        );
        setLoading(false);
      }
    } catch (e) {}
  }

  Future<void> removeTemporaryOwner() async {
    setLoading(true);
    final params = TemporaryOwnerParams(email: null, delegationStartDate: null, delegationEndDate: null);
    final result = await api.removeTemporaryOwner(params);
    result.when(
      success: (data) {
        DialogService.success(
          'Success',
          onCancel: Get.back,
        );
        updateMe();
      },
      failure: (error) {
        DialogService.failure(
          error: error,
        );
      },
    );
    setLoading(false);
  }
}
