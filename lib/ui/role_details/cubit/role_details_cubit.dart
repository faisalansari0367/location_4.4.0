import 'dart:developer';

import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/services/notifications/connectivity/connectivity_service.dart';
import 'package:background_location/ui/maps/view/maps_page.dart';
import 'package:background_location/ui/role_details/models/field_types.dart';
import 'package:background_location/ui/role_details/widgets/property_address.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:background_location/widgets/dialogs/no_signature_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

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
  final LocalApi localApi;
  final List<String> fields;

  late Map<String, dynamic> user;
  final formKey = GlobalKey<FormState>();
  late Api apiService;

  RoleDetailsCubit(this.role, this.localApi, this.api, {this.fields = const []}) : super(const RoleDetailsState()) {
    apiService = api;
    MyConnectivity().connectionStream.listen((event) {
      apiService = event ? api : localApi;
      // emit(state.copyWith())
    });
    emit(state.copyWith(fields: fields));
    user = apiService.getUser()!.toJson();
    _init();
  }

  // final fieldsData = <FieldData>[];

  void _init() async {
    await 200.milliseconds.delay();
    await _getFields();
    await getRoleDetails();
    await getSpecies();
    await getLicenceCategories();

    // api.getLicenceCategories();
    // getLicenceCategories();
    // await Future.wait([
    //   _getFields(),
    //   getRoleDetails(),
    // ]);
  }

  @override
  void emit(RoleDetailsState state) {
    if (isClosed) return;
    entryAndExitDateValidator();
    super.emit(state);
  }

  Future<void> getLicenceCategories() async {
    final result = await api.getLicenceCategories();
    result.when(
      success: (s) {
        emit(state.copyWith(licenseCategories: s));
        // final field = state.fieldsData.where((element) => element.fieldType.isLicenceCategory);
        // if (field.isEmpty) return;
        // field.first.data['licenseCategories'] = s;
        // final index = state.fieldsData.indexOf(field.first);
        // final fieldsData = state.fieldsData;
        // fieldsData[index] = FieldData(
        //   name: field.first.name,
        //   controller: field.first.controller,
        //   data: {'licenseCategories': s},
        // );
        // emit(
        //   state.copyWith(
        //     fieldsData: fieldsData,
        //     licenseCategories: s,
        //   ),
        // );
      },
      failure: (failure) {},
    );
  }

  Map<String, dynamic> get userRoleDetails => state.userRoleDetails;

  Future<void> getRoleDetails() async {
    emit(state.copyWith(isLoading: true));
    final data = await apiService.getRoleData(role);

    data.when(
      success: (data) {
        final userData = api.getUserData();
        userData!.signature = data['data']['signature'];
        api.setUserData(userData);
        emit(
          state.copyWith(
            userRoleDetails: Map<String, dynamic>.from(data['data']),
            isLoading: false,
          ),
        );
        // _getFieldsData();
      },
      failure: _failure,
    );
  }

  Future<void> getSpecies() async {
    if (!['Expo\'s', 'Producer'].contains(role)) return;
    final result = await apiService.getUserSpecies();
    result.when(
      success: (data) {
        final fields = [...state.fieldsData];
        final speciesData = userRoleDetails.containsKey(FieldType.species.name)
            ? List<String>.from(userRoleDetails[FieldType.species.name] ?? [])
            : <String>[];
        if (speciesData.isNotEmpty) {
          for (final element in data.data!) {
            final hasElement = speciesData.contains(element.species);
            if (hasElement) element.value = true;
          }
        }
        fields.add(
          FieldData(
            name: 'Species',
            controller: TextEditingController(),
            data: {'species': data},
          ),
        );
        emit(state.copyWith(fieldsData: fields, userSpecies: data));
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
    for (final e in state.fields) {
      var hasField = false;
      final isMobile = e.toCamelCase == 'mobile';
      final key = e.toCamelCase.replaceAll(String.fromCharCode(0x27), '');
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
        if (e.toCamelCase == FieldType.companyAddress.name) return;
        final controller = TextEditingController();
        final fieldData = FieldData(name: e, controller: controller);
        list.add(fieldData);
      }

      // if (e == 'National Grower Registration (NGR) No:') {
      //   final controller = TextEditingController(text: userRoleDetails['ngr']);
      //   final fieldData = FieldData(name: e, controller: controller);
      //   list.add(fieldData);
      // }
    }

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
          state.fields.indexWhere((element) => element.toCamelCase == FieldType.companyAddress.name);
      if (isCompanyAddress != -1) {
        list.add(
          FieldData(
            name: state.fields[isCompanyAddress],
            controller: TextEditingController(),
            address: address,
          ),
        );
      } else {
        list.add(
          FieldData(
            controller: TextEditingController(),
            name: FieldType.address.name,
            address: address,
          ),
        );
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
    // emit(state.copyWith(isLoading: state.fields.isEmpty));

    // apiService.userRolesStream.listen((event) {
    //   // _success(event);
    //   // emit(state.copyWith(fields: event))
    // });
    // final fields = await apiService.(role);
    // fields.when(success: _success, failure: _failure);
    // emit(state.copyWith(isLoading: false));
  }

  void _failure(NetworkExceptions error) {
    DialogService.failure(error: error);
    emit(state.copyWith(isLoading: false));
  }

  void _success(RoleDetailsModel data) {
    emit(state.copyWith(fields: data.data, isLoading: false));
  }

  void entryAndExitDateValidator() {
    final entryField = state.fieldsData.where((element) => element.fieldType.isEntryDate);
    final exitField = state.fieldsData.where((element) => element.fieldType.isExitDate);
    if (entryField.isNotEmpty && exitField.isNotEmpty) {
      final entry = DateTime.parse(entryField.first.controller.text);
      final exit = DateTime.parse(exitField.first.controller.text);
      var message = '';
      if (entry.isAfter(exit)) {
        message = 'Entry date cannot be after exit date';
      } else if (entry.compareTo(exit) == 0) {
        message = 'Entry date cannot be equal to exit date';
      } else if (entry.isBefore(DateTime.now().subtract(10.days)) && state.userRoleDetails['role'] != 'Employee') {
        message = "Can't be more than 10 days before today's date";
      } else if (exit.difference(entry).inDays > 10) {
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
      for (final field in state.fieldsData) {
        if (field.fieldType.isAddress) {
          final _address = field.address!.toMap();
          // _address['state'] = 'STATE';
          data.addAll(_address);
          return;
        } else if (field.fieldType.isCompanyAddress) {
          final _address = field.address!.toMap();
          data.addAll(_address);
          return;
        } else if (field.fieldType.isSpecies) {
          // data.addAll( (field.data['species'] as UserSpecies).tojs);
          final species = field.data['species'] as UserSpecies;
          final list = (species.data ?? []).where((element) => element.value == true).map((e) => e.species).toList();
          if (list.isEmpty) return;
          data[field.fieldType.name] = list;
          return;
        }
        data[field.name.toCamelCase.replaceAll(String.fromCharCode(0x27), '')] = field.controller.text.trim();
      }

      if (data.containsKey(FieldType.countryOfOrigin.name) && data.containsKey(FieldType.countryVisiting.name)) {
        if (data[FieldType.countryOfOrigin.name] == data[FieldType.countryVisiting.name]) {
          await DialogService.showDialog(
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
          message = "Can't be more than 10 days before today's date";
        } else if (exitDate.difference(entryDate).inDays > 10) {
          message = 'Entry date cannot be more than 10 days after today';
        }
        if (message.isNotEmpty) {
          await DialogService.showDialog(
            child: NetworkErrorDialog(
              message: message,
              onCancel: Get.back,
            ),
          );
          return;
        }
      }
      // final ngrKey = 'nationalGrowerRegistration(ngr)No:';
      // if (data.containsKey(ngrKey)) {
      //   final ngrValue = data[ngrKey];
      //   data.remove(ngrKey);
      //   data['ngr'] = ngrValue;
      // }
      // final role = apiService.getUser()!.role!;
      final result = await apiService.updateRole(role, data);
      result.when(
        success: (data) => Get.to(() => const MapsPage()),
        failure: (error) => DialogService.failure(
          error: error,
          // onCancel: () => Get.to(() => MapsPage()),
          onCancel: Get.back,
        ),
      );
    }
  }

  Future<void> submitFormData(Map<String, dynamic> data) async {
    if (formKey.currentState?.validate() ?? false) {
      final hasSignature = data.containsKey(FieldType.signature.name);
      if (hasSignature) {
        if (['', null].contains(data[FieldType.signature.name])) {
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

      // final data = <String, dynamic>{};
      // state.fieldsData.forEach((field) {
      //   if (field.fieldType.isAddress) {
      //     final _address = field.address!.toMap();
      //     // _address['state'] = 'STATE';
      //     data.addAll(_address);
      //     return;
      //   } else if (field.fieldType.isCompanyAddress) {
      //     final _address = field.address!.toMap();
      //     data.addAll(_address);
      //     return;
      //   } else if (field.fieldType.isSpecies) {
      //     // data.addAll( (field.data['species'] as UserSpecies).tojs);
      //     final UserSpecies species = field.data['species'] as UserSpecies;
      //     final list = (species.data ?? []).where((element) => element.value == true).map((e) => e.species).toList();
      //     if (list.isEmpty) return;
      //     data[field.fieldType.name] = (list);
      //     return;
      //   }
      //   data[field.name.toCamelCase.replaceAll(String.fromCharCode(0x27), '')] = field.controller.text.trim();
      // });

      if (data.containsKey(FieldType.countryOfOrigin.name) && data.containsKey(FieldType.countryVisiting.name)) {
        if (data[FieldType.countryOfOrigin.name] == data[FieldType.countryVisiting.name]) {
          await DialogService.showDialog(
            child: NetworkErrorDialog(
              message: 'Country of origin and country visiting cannot be the same',
              onCancel: Get.back,
            ),
          );
          return;
        }
      }

      if (data.containsKey('startDate') && data.containsKey('endDate')) {
        var message = '';
        final entryDate = DateTime.parse(data['startDate']);
        final exitDate = DateTime.parse(data['endDate']);
        print(exitDate.difference(entryDate).inDays);
        if (entryDate.isAfter(exitDate)) {
          message = 'Entry date cannot be after exit date';
        } else if (entryDate.compareTo(exitDate) == 0) {
          message = 'Entry date cannot be equal to exit date';
        } else if (entryDate.isBefore(DateTime.now().subtract(10.days))) {
          message = "Can't be more than 10 days before today's date";
        } else if (exitDate.difference(entryDate).inDays > 10) {
          message = 'Entry date cannot be more than 10 days after today';
        }
        if (message.isNotEmpty) {
          await DialogService.showDialog(
            child: NetworkErrorDialog(
              message: message,
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
          message = "Can't be more than 10 days before today's date";
        } else if (exitDate.difference(entryDate).inDays > 10) {
          message = 'Entry date cannot be more than 10 days after today';
        }
        if (message.isNotEmpty) {
          await DialogService.showDialog(
            child: NetworkErrorDialog(
              message: message,
              onCancel: Get.back,
            ),
          );
          return;
        }
      }

      if (state.userSpecies != null) {
        final list = state.userSpecies!.data!.where((element) => element.value == true).map((e) => e.species).toList();
        data['species'] = list;
      }

      // final ngrKey = 'nationalGrowerRegistration(ngr)No:';
      // if (data.containsKey(ngrKey)) {
      //   final ngrValue = data[ngrKey];
      //   data.remove(ngrKey);
      //   data['ngr'] = ngrValue;
      // }
      // final role = apiService.getUser()!.role!;

      // change mobile key
      const mobileKey = 'mobile';

      if (data.containsKey(mobileKey)) {
        final mobileValue = data[mobileKey];
        data.remove(mobileKey);
        data['phoneNumber'] = mobileValue;
      }

      // change ngr key
      const ngrKey = 'nationalGrowerRegistration(ngr)No:';
      if (data.containsKey(ngrKey)) {
        final ngrValue = data[ngrKey];
        data.remove(ngrKey);
        data['ngr'] = ngrValue;
      }

      const licenseKey = "driver'sLicense";
      if (data.containsKey(licenseKey)) {
        final ngrValue = data[licenseKey];
        data.remove(licenseKey);
        data['driversLicense'] = ngrValue;
      }

      final result = await apiService.updateRole(role, data);
      result.when(
        success: (data) => Get.to(() => const MapsPage()),
        failure: (error) => DialogService.failure(
          error: error,
          // onCancel: () => Get.to(() => MapsPage()),
          onCancel: Get.back,
        ),
      );
    }
  }
}
