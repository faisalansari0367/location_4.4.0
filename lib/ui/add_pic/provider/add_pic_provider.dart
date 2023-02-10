import 'package:api_repo/api_repo.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/widgets/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPicNotifier extends BaseModel {
  AddPicNotifier(super.context);

  AddPicParams state = AddPicParams();

  final formKey = GlobalKey<FormState>();

  void onPicChanged(String value) => emit(state.copyWith(pic: value));
  void onNgrChanged(String value) => emit(state.copyWith(ngr: value));
  void onCompanyChanged(String value) =>
      emit(state.copyWith(companyName: value));
  void onPropertyChanged(String value) =>
      emit(state.copyWith(propertyName: value));
  void onOwnerChanged(String value) => emit(state.copyWith(owner: value));
  void onStreetChanged(String value) => emit(state.copyWith(street: value));
  void onTownChanged(String value) => emit(state.copyWith(town: value));
  void onStateChanged(String value) => emit(state.copyWith(state: value));
  void onPostCodeChanged(String value) => emit(state.copyWith(postcode: value));

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final result = await api.createPic(params: state);
      result.when(
        success: success,
        failure: failure,
      );
    }
  }

  void emit(AddPicParams state) {
    this.state = state;
    notifyListeners();
  }

  Object? success(PicModel data) {
    DialogService.success(
      'Pic added successfully',
      onCancel: Get.back,
    );
    return null;
  }

  Object? failure(NetworkExceptions error) {
    DialogService.failure(error: error);
    return null;
  }
}
