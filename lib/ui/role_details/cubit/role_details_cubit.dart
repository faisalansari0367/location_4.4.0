import 'dart:developer';

import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/src/user/src/models/role_details_model.dart';
import 'package:background_location/ui/maps/view/maps_page.dart';
import 'package:background_location/ui/role_details/models/field_types.dart';
import 'package:background_location/ui/role_details/widgets/property_address.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:background_location/widgets/dialogs/no_signature_found.dart';
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

class RoleDetailsCubit extends Cubit<RoleDetailsState> {
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
    await _getFields();
    await getRoleDetails();
    // await Future.wait([
    //   _getFields(),
    //   getRoleDetails(),
    // ]);
  }

  @override
  emit(RoleDetailsState state) {
    if (isClosed) return;
    super.emit(state);
  }

  Map<String, dynamic> get userRoleDetails => state.userRoleDetails;

  Future<void> getRoleDetails() async {
    emit(state.copyWith(isLoading: true));
    final data = await api.getRoleData();

    data.when(
      success: (data) {
        emit(state.copyWith(userRoleDetails: Map<String, dynamic>.from(data['data']), isLoading: false));
        _getFieldsData();
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
  }

  void _getFieldsDataFromFields(Map<String, bool> addressFields, List<FieldData> list) {
    // emit(state.copyWith(fields: [...state.fields, 'cit]));
    state.fields.forEach((e) {
      var hasField = false;
      final isMobile = e.camelCase == 'mobile';
      final key = e.camelCase!.replaceAll(String.fromCharCode(0x27), '');
      if (isMobile) {
        hasField = userRoleDetails.containsKey('phoneNumber');
      } else {
        hasField = userRoleDetails.containsKey(key);
      }
      if (hasField) {
        try {
          if (addressFields.containsKey(e.toLowerCase())) {
            addressFields[e.toLowerCase()] = true;
          } else {
            final controller =
                TextEditingController(text: isMobile ? userRoleDetails['phoneNumber'] : userRoleDetails[key]);
            final fieldData = FieldData(name: isMobile ? 'Phone Number' : e, controller: controller);
            list.add(fieldData);
          }
        } on Exception catch (e) {
          log(e.toString());
        }
      } else {
        if (e.camelCase == FieldType.companyAddress.name) return;
        final controller = TextEditingController();
        final fieldData = FieldData(name: e, controller: controller);
        list.add(fieldData);
      }
    });

    final map = <String, dynamic>{};
    addressFields.forEach((key, value) {
      if (addressFields[key] ?? false) {
        map[key] = userRoleDetails[key] ?? '';
      } else {
        map[key] = '';
      }
    });

    if (addressFields.containsValue(true)) {
      addressFields.removeWhere((key, value) => addressFields[key] == false);
      final address = Address.fromMap(map);
      address.fieldsToShow = addressFields;

      final isCompanyAddress =
          state.fields.indexWhere((element) => element.camelCase! == FieldType.companyAddress.name);
      if (isCompanyAddress != -1) {
        // final companyAddress = Address.fromMap(userRoleDetails[isCompanyAddress.camelCase]!);
        // companyAddress.fieldsToShow = addressFields;
        list.add(
          FieldData(
            name: state.fields[isCompanyAddress],
            controller: TextEditingController(),
            address: address,
          ),
        );
      } else {
        // list.add(FieldData(name: 'companyAddress', controller: TextEditingController(text: address.toString()), address: address));

        list.add(FieldData(
          controller: TextEditingController(),
          name: FieldType.address.name,
          address: address,
        ));
      }
    }
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
    // emit(state.copyWith(isLoading: false));
  }

  void _failure(NetworkExceptions error) {
    DialogService.failure(error: error);
    emit(state.copyWith(isLoading: false));
  }

  void _success(RoleDetailsModel data) {
    emit(state.copyWith(fields: data.data, isLoading: false));
  }

  Future<void> onSubmit() async {
    if (formKey.currentState?.validate() ?? false) {
      final hasSignature = state.fieldsData.firstWhereOrNull((element) => element.fieldType.isSignature);
      if (hasSignature != null) {
        if (hasSignature.controller.text.isEmpty) {
          await DialogService.showDialog(
            child: NoSignatureFound(
              message: 'No signature found',
              subtitle: 'Please add signature and try again',
              buttonText: 'Ok',
              onCancel: Get.back,
            ),
          );
          return;
        }
      }
      // Get.to(() => const MapsPage());
      final data = <String, dynamic>{};
      state.fieldsData.forEach((field) {
        // if (field.fieldType.isSignature) {
        //   final isEmpty = field.controller.text.isEmpty;
        //   if (isEmpty) {
        //     DialogService.showDialog(
        //       child: NoSignatureFound(
        //         message: 'No signature found',
        //         subtitle: 'Please tap the below button to add signature',
        //         buttonText: 'Add signature',
        //         onCancel: () async {
        //           await Get.to(
        //             () => SignatureWidget(
        //               onChanged: (value) {
        //                 field.controller.text = value;
        //               },
        //             ),
        //           );
        //           Get.back();
        //         },
        //       ),
        //     );
        //     return;
        //   }
        // }
        if (field.fieldType.isAddress) {
          final _address = field.address!.toMap();
          // _address['state'] = 'STATE';
          data.addAll(_address);
          return;
        } else if (field.fieldType.isCompanyAddress) {
          final _address = field.address!.toMap();
          data.addAll(_address);
          return;
        }
        data[field.name.camelCase!.replaceAll(String.fromCharCode(0x27), '')] = field.controller.text.trim();
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
        print(exitDate.difference(entryDate).inDays);
        if (entryDate.isAfter(exitDate)) {
          message = 'Entry date cannot be after exit date';
        } else if (entryDate.compareTo(exitDate) == 0) {
          message = 'Entry date cannot be equal to exit date';
        } else if (entryDate.isBefore(DateTime.now().subtract(10.days))) {
          message = "Can't be more than 10 days from today's date";
        } else if (exitDate.difference(entryDate).inDays > 10) {
          message = 'Entry date cannot be more than 10 days after today';
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

      // if()

      final result = await api.updateRole(data);
      result.when(
        success: (data) => Get.to(() => MapsPage()),
        failure: (error) => DialogService.failure(
          error: error,
          // onCancel: () => Get.to(() => MapsPage()),
          onCancel: Get.back,
        ),
      );
    }
  }

  // @override
  // RoleDetailsState? fromJson(Map<String, dynamic> json) {
  //   return RoleDetailsState.fromJson(json);
  // }

  // @override
  // Map<String, dynamic>? toJson(RoleDetailsState state) {
  //   return state.toJson();
  // }
}
