import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/src/user/src/models/role_details_model.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../maps/view/maps_page.dart';
import '../models/field_data.dart';

part 'role_details_state.dart';

class RoleDetailsCubit extends Cubit<RoleDetailsState> {
  final String role;
  final Api api;

  late Map<String, dynamic> user;
  RoleDetailsCubit(this.role, this.api) : super(RoleDetailsState()) {
    getFields();
    user = api.getUser()!.toJson();
  }

  final formKey = GlobalKey<FormState>();

  Future<void> getFields() async {
    emit(state.copyWith(isLoading: true));
    final fields = await api.getFields();
    fields.when(success: success, failure: failure);
  }

  void failure(NetworkExceptions error) {
    DialogService.failure(error: error);
    emit(state.copyWith(isLoading: false));
  }

  void success(RoleDetailsModel data) {
    final fieldsData = data.data.map(
      (field) {
        return FieldData(
          name: field,
          controller: TextEditingController(text: _fillUserDetails(field)),
        );
      },
    ).toList();
    emit(state.copyWith(fields: fieldsData, isLoading: false));
  }

  String _fillUserDetails(String field) {
    final fieldType = FieldData.getFieldType(field);
    if (user.containsKey(fieldType.name)) {
      return user[fieldType.name];
    } else {
      return '';
    }
  }

  Future<void> onSubmit() async {
    if (formKey.currentState?.validate() ?? false) {
      Get.to(() => const MapsPage());
    }
  }
}
