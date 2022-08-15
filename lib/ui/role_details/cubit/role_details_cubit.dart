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

import '../../../widgets/dialogs/network_error_dialog.dart';
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
  final formKey = GlobalKey<FormState>();

  RoleDetailsCubit(this.role, this.api) : super(RoleDetailsState()) {
    user = api.getUser()!.toJson();
    _init();
  }

  // final fieldsData = <FieldData>[];

  void _init() async {
    // await getFields();
    // await getRoleDetails();
    await Future.wait([
      _getFields(),
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

  Map<String, dynamic> get userRoleDetails => state.userRoleDetails;

  Future<void> getRoleDetails() async {
    final data = await api.getRoleData();

    data.when(
      success: (data) {
        final details = data.data!.toJson();
        emit(state.copyWith(userRoleDetails: details));
        _getFieldsData();
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
      failure: _failure,
    );
  }

  void _getFieldsData() {
    final fieldsData = <FieldData>[];
    final addressFields = {'street': false, 'town': false, 'state': false, 'postcode': false, 'address': false};
    _getFieldsDataFromFields(addressFields, fieldsData);
    final signatureIndex = fieldsData.indexWhere((element) => element.fieldType.isSignature);
    final addressIndex = fieldsData.indexWhere((element) => element.fieldType.isAddress);
    _addElementToLast(addressIndex, fieldsData);
    _addElementToLast(signatureIndex, fieldsData);
    emit(state.copyWith(fieldsData: List<FieldData>.from(fieldsData)));
    // return fieldsData;
  }

  void _getFieldsDataFromFields(Map<String, bool> addressFields, List<FieldData> list) {
    state.fields.forEach((e) {
      final hasField = userRoleDetails.containsKey(e.camelCase);
      if (hasField) {
        // final controller = TextEditingController(text: ((userRoleDetails[e.camelCase] ?? '') as String).capitalizeFirst!);
        final controller = TextEditingController(text: userRoleDetails[e.camelCase]);

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
        map[key] = userRoleDetails[key] ?? '';
      } else {
        map[key] = null;
      }
    });
    // addressFields.containsValue(value)
    if (addressFields.containsValue(true))
      list.add(FieldData(
        controller: TextEditingController(text: userRoleDetails['address']),
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

  Future<void> _getFields() async {
    if (state.fields.isNotEmpty) {
      _getFieldsData();
    }
    emit(state.copyWith(isLoading: state.fields.isEmpty));
    final fields = await api.getFields();
    fields.when(success: _success, failure: _failure);
    emit(state.copyWith(isLoading: false));
  }

  void _failure(NetworkExceptions error) {
    DialogService.failure(error: error);
  }

  void _success(RoleDetailsModel data) {
    emit(state.copyWith(fields: data.data));
  }

  // String _fillUserDetails(String field) {
  // }

  Future<void> onSubmit() async {
    if (formKey.currentState?.validate() ?? false) {
      // Get.to(() => const MapsPage());
      final data = <String, dynamic>{};
      state.fieldsData.forEach((field) {
        if (field.fieldType.isAddress) {
          final _address = field.address!.toMap();
          data.addAll(_address);
          // data[field.fieldType.name] =
          //     '${field.address?.street} ${field.address?.town} ${field.address?.state} ${field.address?.postcode}';
          // data['address'] = '';
        } else if (field.fieldType.isPhoneNumber) {
          data[field.fieldType.name] = field.controller.text;
        } else {
          data[field.name.camelCase!] = field.controller.text;
        }
      });

      if (data.containsKey(FieldType.countryOfOrigin.name) && data.containsKey(FieldType.countryVisiting.name)) {
        if (data[FieldType.countryOfOrigin.name] == data[FieldType.countryVisiting.name]) {
          DialogService.showDialog(
            child: NetworkErrorDialog(
              message: 'Country of origin and country visiting cannot be the same',
              onCancel: Get.back,
            ),
          );
          return;
        }
      }

      if (data.containsKey('entryDate') && data.containsKey('exitDate')) {
        var message = '';
        final entryDate = DateTime.parse(data['entryDate']);
        final exitDate = DateTime.parse(data['exitDate']);
        if (entryDate.isAfter(exitDate)) {
          message = 'Entry date cannot be after exit date';
        } else if (entryDate.compareTo(exitDate) == 0) {
          message = 'Entry date cannot be equal to exit date';
        }
        if (message.isNotEmpty) {
          DialogService.showDialog(
            child: NetworkErrorDialog(
              message: message,
              onCancel: Get.back,
            ),
          );
          return;
        }
      }

      final result = await api.updateRole(data);
      result.when(
        success: (data) => Get.to(() => MapsPage()),
        failure: (error) => DialogService.failure(
          error: error,
          onCancel: () => Get.to(() => MapsPage()),
        ),
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
