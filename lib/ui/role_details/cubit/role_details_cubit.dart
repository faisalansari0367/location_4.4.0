import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/src/user/src/models/role_details_model.dart';
import 'package:background_location/ui/maps/view/maps_page.dart';
import 'package:background_location/ui/role_details/models/field_types.dart';
import 'package:background_location/ui/role_details/widgets/property_address.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../models/field_data.dart';
import 'role_details_state.dart';

export 'role_details_state.dart';

// part 'role_details_state.dart';
// part 'role_details_state.g.dart';
// import 'package:json_annotation/json_annotation.dart';

class RoleDetailsCubit extends HydratedCubit<RoleDetailsState> {
  final String role;
  final Api api;

  late Map<String, dynamic> user;
  RoleDetailsCubit(this.role, this.api) : super(RoleDetailsState()) {
    user = api.getUser()!.toJson();
    _init();
  }

  void _init() async {
    // await getFields();
    // await getRoleDetails();
    await Future.wait([
      getFields(),
      getRoleDetails(),
    ]);
  }

  @override
  emit(RoleDetailsState state) {
    if (isClosed) {
      return;
    }
    super.emit(state);
  }

  Future<void> getRoleDetails() async {
    final data = await api.getRoleData();
    data.when(
      success: (data) {
        final details = data.data!.toJson();
        emit(state.copyWith(userRoleDetails: details));
        // state.fields.forEach((e) {
        //   final hasField = details.containsKey(e.camelCase);
        //   if (hasField) {
        //     final controller = TextEditingController(text: details[e.camelCase]);
        //     if (addressFields.containsKey(e.toLowerCase())) {
        //       addressFields[e.toLowerCase()] = true;
        //     } else {
        //       final fieldData = FieldData(name: e, controller: controller);
        //       list.add(fieldData);
        //     }
        //   }
        // });
        // final map = <String, dynamic>{};
        // addressFields.forEach((key, value) {
        //   if (addressFields[key] ?? false) {
        //     map[key] = details[key] ?? '';
        //   } else {
        //     map[key] = null;
        //   }
        // });

        // list.add(FieldData(
        //   name: 'address',
        //   address: Address.fromMap(map),
        //   // address: Address(

        //   // ),
        //   controller: TextEditingController(text: details['address']),
        // ));
        // final signatureIndex = list.indexWhere((element) => element.fieldType.isSignature);
        // final addressIndex = list.indexWhere((element) => element.fieldType.isAddress);
        // addElementToLast(addressIndex, list);
        // addElementToLast(signatureIndex, list);
        // emit(state.copyWith(isLoading: false, fieldsData: list));
      },
      failure: failure,
    );
  }

  List<FieldData> getFieldsData() {
    final list = <FieldData>[];
    final addressFields = {'street': false, 'town': false, 'state': false, 'postcode': false, 'address': false};

    _getFieldsDataFromFields(addressFields, list);
    final signatureIndex = list.indexWhere((element) => element.fieldType.isSignature);
    final addressIndex = list.indexWhere((element) => element.fieldType.isAddress);
    _addElementToLast(addressIndex, list);
    _addElementToLast(signatureIndex, list);

    return list;
  }

  void _getFieldsDataFromFields(Map<String, bool> addressFields, List<FieldData> list) {
    state.fields.forEach((e) {
      final hasField = state.userRoleDetails.containsKey(e.camelCase);
      if (hasField) {
        final controller = TextEditingController(text: state.userRoleDetails[e.camelCase]);
        if (addressFields.containsKey(e.toLowerCase())) {
          addressFields[e.toLowerCase()] = true;
        } else {
          final fieldData = FieldData(name: e, controller: controller);
          list.add(fieldData);
        }
      }
    });

    final map = <String, dynamic>{};
    addressFields.forEach((key, value) {
      if (addressFields[key] ?? false) {
        map[key] = state.userRoleDetails[key] ?? '';
      } else {
        map[key] = null;
      }
    });
    // addressFields.containsValue(value)
    if (addressFields.containsValue(true))
      list.add(FieldData(
        controller: TextEditingController(text: state.userRoleDetails['address']),
        name: 'address',
        address: Address.fromMap(map),
      ));
  }

  void _addElementToLast(int index, List<FieldData> fieldsData) {
    if (index != -1) {
      final item = fieldsData[index];
      fieldsData.removeAt(index);
      fieldsData.insert(fieldsData.length, item);
    }
  }

  final formKey = GlobalKey<FormState>();

  Future<void> getFields() async {
    emit(state.copyWith(isLoading: state.fields.isEmpty));
    final fields = await api.getFields();
    fields.when(success: success, failure: failure);
    emit(state.copyWith(isLoading: false));
  }

  void failure(NetworkExceptions error) {
    DialogService.failure(error: error);
  }

  void success(RoleDetailsModel data) {
    emit(state.copyWith(fields: data.data));
  }

  // String _fillUserDetails(String field) {
  // }

  Future<void> onSubmit() async {
    if (formKey.currentState?.validate() ?? false) {
      // Get.to(() => const MapsPage());
      final data = <String, dynamic>{};
      getFieldsData().forEach((field) {
        if (field.fieldType.isAddress) {
          data.addAll(field.address!.toMap());
          // data[field.fieldType.name] =
          //     '${field.address?.street} ${field.address?.town} ${field.address?.state} ${field.address?.postcode}';
          // data['address'] = '';
        } else if (field.fieldType.isPhoneNumber) {
          data[field.fieldType.name] = field.controller.text;
        } else {
          data[field.name.camelCase!] = field.controller.text;
        }
      });

      final result = await api.updateRole(data);
      result.when(
        success: (data) => Get.to(() => MapsPage()),
        failure: (error) {
          DialogService.failure(
            error: error,
          );
        },
      );
    }
  }

  // @override
  // void onChange(Change<RoleDetailsState> change) {
  //   if (isClosed) return;
  //   super.onChange(change);
  // }

  @override
  RoleDetailsState? fromJson(Map<String, dynamic> json) {
    return RoleDetailsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(RoleDetailsState state) {
    return state.toJson();
  }
}
