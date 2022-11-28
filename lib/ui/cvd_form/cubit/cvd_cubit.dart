import 'dart:convert';

import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/src/api/api_repo.dart';
import 'package:api_repo/src/local_api/src/local_api.dart';
import 'package:api_repo/src/user/src/models/user_forms_data.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/services/notifications/forms_storage_service.dart';
import 'package:background_location/ui/cvd_form/models/chemical_use.dart';
import 'package:background_location/ui/cvd_form/models/cvd_form_data.dart';
import 'package:background_location/ui/cvd_form/models/product_integrity_details_model.dart';
import 'package:background_location/ui/cvd_form/models/transporter_details_model.dart';
import 'package:background_location/ui/cvd_form/widgets/form_stepper.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';

import '../models/buyer_details_model.dart';
import '../models/commodity_details_model.dart';
import '../models/vendor_details_model.dart';

part 'cvd_state.dart';

class CvdCubit extends Cubit<CvdState> {
  final Api api;
  final LocalApi localApi;
  late Box _box;

  CvdCubit({required this.api, required this.localApi}) : super(const CvdState()) {
    // getCvdForm();
  }

  void init(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    _box = await Hive.openBox('cvdbox');
    final futures = [
      _fetchVendorDetailsModel(context),
      _fetchBuyerDetailsModel(context),
      _fetchTransporterDetailsModel(context),
      _fetchCommodityDetailsModel(context),
      _fetchChemicalUseDetailsModel(context),
      _fetchPartIntegrityDetailsModel(context),
    ];
    await Future.wait(futures);
    _fromJson();
    emit(state.copyWith(isLoading: false));
  }

  String? signature, organisationName;
  String riskAssesment = '';
  String testResults = '';

  VendorDetailsModel vendorDetails = VendorDetailsModel();
  BuyerDetailsModel buyerDetailsModel = BuyerDetailsModel();
  TransporterDetailsModel transporterDetails = TransporterDetailsModel();
  CommodityDetailsModel commodityDetails = CommodityDetailsModel();
  ChemicalUseDetailsModel chemicalUseDetailsModel = ChemicalUseDetailsModel();
  ProductIntegrityDetailsModel productIntegrityDetailsModel = ProductIntegrityDetailsModel();

  Future<void> _fetchVendorDetailsModel(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    final data = await DefaultAssetBundle.of(context).loadString('assets/json/vendor_details.json');
    final map = jsonDecode(data);
    vendorDetails = VendorDetailsModel.fromJson(map);
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _fetchBuyerDetailsModel(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    final data = await DefaultAssetBundle.of(context).loadString('assets/json/buyer_details.json');
    final map = jsonDecode(data);
    buyerDetailsModel = BuyerDetailsModel.fromJson(map);
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _fetchTransporterDetailsModel(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    final data = await DefaultAssetBundle.of(context).loadString('assets/json/transporter_details.json');
    final map = jsonDecode(data);
    transporterDetails = TransporterDetailsModel.fromJson(map);
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _fetchCommodityDetailsModel(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    final data = await DefaultAssetBundle.of(context).loadString('assets/json/commodity_details.json');
    final map = jsonDecode(data);
    commodityDetails = CommodityDetailsModel.fromJson(map);
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _fetchChemicalUseDetailsModel(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    final data = await DefaultAssetBundle.of(context).loadString('assets/json/chemical_use.json');
    final map = jsonDecode(data);
    chemicalUseDetailsModel = ChemicalUseDetailsModel.fromJson(map);
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _fetchPartIntegrityDetailsModel(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    final data = await DefaultAssetBundle.of(context).loadString('assets/json/part_integrity_form.json');
    final map = jsonDecode(data);
    productIntegrityDetailsModel = ProductIntegrityDetailsModel.fromJson(map['data']);
    emit(state.copyWith(isLoading: false));
  }

  final map = {};
  final PageController pageController = PageController();
  final ScrollController stepController = ScrollController();

  final List<String> stepNames = [
    'Vendor\nDetails',
    'Buyer\nDetails',
    'Transporter',
    'Commodity\nDetails',
    'Product\nIntegrity',
    'Chemical\nUse',
    'Self\nDeclaration'
  ];
  final List<bool> stepCompleted = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  void changeCurrent(int step, {bool isNext = false, bool isPrevious = false}) {
    late var _step = step;

    if (isNext) {
      step = state.currentStep + 1;
    } else if (isPrevious) {
      step = state.currentStep - 1;
    }
    stepCompleted[_step] = true;
    emit(state.copyWith(currentStep: _step));
    moveToPage(_step);
  }

  void moveToNext() {
    final page = state.currentStep + 1;
    stepCompleted[state.currentStep] = true;
    emit(state.copyWith(currentStep: page));
    saveFormData();
    pageController.animateToPage(
      page,
      curve: Curves.fastOutSlowIn,
      duration: 500.milliseconds,
    );
    if (page > 1) {
      stepController.animateTo(
        (90 * page).toDouble(),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void saveFormData() => _toJson();

  void moveToPage(int page) {
    if (page != 0) {
      if (!stepCompleted[page - 1]) {
        return;
      }
    }
    if (page > 1) {
      stepController.animateTo(
        (90 * page).toDouble(),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    emit(state.copyWith(currentStep: page));
    pageController.animateToPage(
      page,
      curve: Curves.fastOutSlowIn,
      duration: 500.milliseconds,
    );
  }

  Future<void> getApiData() async {
    // emit(state.copyWith(isLoading: true));
    try {
      final result = await Dio().post(
        'https://uniquetowinggoa.com/safemeat/public/api/declaration',
        data: _cvdFormData,
      );
      if (result.data['status'] == false) {
        final error = result.data['data'] as Map;
        DialogService.error('${result.data['message']} \n ${error.values.first}');
        return;
      }
      final formsService = FormsStorageService(api);
      final bytes = base64Decode(result.data['data']);
      final file = await formsService.saveCvdForm(bytes, buyerDetailsModel.name?.value ?? '');
      await OpenFile.open(file.path);
      Get.close(2);
    } catch (e) {
      print(e);
    }
    // emit(state.copyWith(isLoading: false));
  }

  Map<String, Object?> get _cvdFormData {
    return {
      'vendorName': vendorDetails.name!.value,
      'vendorAddress': vendorDetails.address!.value,
      'vendorTown': vendorDetails.town!.value,
      'vendorContact': (vendorDetails.tel!.value),
      'vendorFax': vendorDetails.fax!.value,
      'vendorEmail': vendorDetails.email!.value,
      'vendorNGR': vendorDetails.ngr!.value,
      'vendorPIC': vendorDetails.pic!.value,
      'vendorReference': vendorDetails.refrenceNo!.value,
      'buyerName': buyerDetailsModel.name!.value,
      'buyerAddress': buyerDetailsModel.address!.value,
      'buyerTown': buyerDetailsModel.town!.value,
      'buyerContact': buyerDetailsModel.tel!.value,
      'buyerFax': buyerDetailsModel.fax!.value,
      'buyerEmail': buyerDetailsModel.email!.value,
      'buyerNGR': buyerDetailsModel.ngr!.value,
      'buyerPIC': buyerDetailsModel.pic!.value,
      'buyerReference': buyerDetailsModel.contractNo!.value,
      'driverName': transporterDetails.name?.value,
      'driverEmail': transporterDetails.email?.value,
      'driverContact': transporterDetails.mobile?.value,
      'companyName': transporterDetails.company?.value,
      'registration': transporterDetails.registration?.value,
      'commodity': commodityDetails.commodity!.value,
      // 'period': '30',
      'period': MyDecoration.formatDate(DateTime.tryParse(commodityDetails.deliveryPeriod!.value!)),
      'variety1': commodityDetails.variety1!.value,
      'variety2': commodityDetails.variety2!.value,
      'quantity1': commodityDetails.quantity1!.value,
      'quantity2': commodityDetails.quantity2!.value,
      'sourceCheck': productIntegrityDetailsModel.sourceCheck?.value,
      'materialCheck': productIntegrityDetailsModel.materialCheck?.value,
      'gmoCheck': productIntegrityDetailsModel.gmoCheck?.value,
      'chemicalCheck': chemicalUseDetailsModel.chemicalCheck?.value,
      // 'chemicals': [
      //   {'chemicalName': 'chemical1', 'rate': '200', 'applicationDate': '2022-08-25', 'WHP': '456'},
      //   {'chemicalName': 'chemical2', 'rate': '2000', 'applicationDate': '2022-08-27', 'WHP': '753'},
      //   {'chemicalName': 'chemical3', 'rate': '2650', 'applicationDate': '2022-08-21', 'WHP': '1369'},
      //   {'chemicalName': 'chemical4', 'rate': '800', 'applicationDate': '2022-04-25', 'WHP': '789'}
      // ],
      'chemicals': chemicalUseDetailsModel.chemicalTable.map((e) => e.toJson()).toList(),
      'qaCheck': chemicalUseDetailsModel.qaCheck?.value,
      'qaProgram': chemicalUseDetailsModel.qaProgram?.value,
      'certificateNumber': chemicalUseDetailsModel.certificateNumber?.value,
      'cvdCheck': chemicalUseDetailsModel.cvdCheck?.value,
      'organisationName': organisationName,
      'riskAssesment': riskAssesment,
      'testResult': testResults,
      // 'cropList': [
      //   {'cropName': 'crop1'},
      //   {'cropName': 'crop2'},
      //   {'cropName': 'crop3'},
      //   {'cropName': 'crop4'}
      // ],
      'cropList': chemicalUseDetailsModel.cropList?.value == null
          ? []
          : chemicalUseDetailsModel.cropList?.value!.split(',').map((e) => {'cropName': e}).toList(),
      'riskCheck': chemicalUseDetailsModel.riskCheck?.value,
      // 'organisationName':
      'nataCheck': chemicalUseDetailsModel.nataCheck?.value,
      'signature': signature,
    };
  }

  bool isStepCompleted(int index) {
    final key = stepCompleted.elementAt(index);
    // final data = state.data.containsKey(key);
    return key;
  }

  void addFormData(Map data) {
    final map = {...state.data};
    final stepName = stepNames[state.currentStep];
    map.addAll({stepName: data});
    emit(state.copyWith(data: map));
  }

  Object? failure(NetworkExceptions error) {
    return null;
  }

  void success(UserFormsData data) {
    emit(state.copyWith(forms: data.data?.forms));
    // data.data.forms;
  }

  void _toJson() {
    final json = {
      'vendorDetails': vendorDetails.toJson(),
      'buyerDetailsModel': buyerDetailsModel.toJson(),
      'transporterDetails': transporterDetails.toJson(),
      'commodityDetails': commodityDetails.toJson(),
      'chemicalUseDetailsModel': chemicalUseDetailsModel.toJson(),
      'productIntegrityDetailsModel': productIntegrityDetailsModel.toJson(),
    };
    _box.put('json', json);
  }

  void _fromJson() {
    final json = _box.get('json');
    if (json == null) return;
    if (json['vendorDetails'] != null) vendorDetails = VendorDetailsModel.fromJson(json['vendorDetails']);
    // vendorDetails = VendorDetailsModel.fromJson(json['venderDetails'] );
    if (json['buyerDetailsModel'] != null) buyerDetailsModel = BuyerDetailsModel.fromJson(json['buyerDetailsModel']);
    if (json['transporterDetails'] != null)
      transporterDetails = TransporterDetailsModel.fromJson(json['transporterDetails']);
    if (json['commodityDetails'] != null) commodityDetails = CommodityDetailsModel.fromJson(json['commodityDetails']);
    if (json['chemicalUseDetailsModel'] != null)
      chemicalUseDetailsModel = ChemicalUseDetailsModel.fromJson(json['chemicalUseDetailsModel']);
    if (json['productIntegrityDetailsModel'] != null)
      productIntegrityDetailsModel = ProductIntegrityDetailsModel.fromJson(json['productIntegrityDetailsModel']);
  }
}
