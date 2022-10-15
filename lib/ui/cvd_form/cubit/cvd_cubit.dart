import 'dart:convert';

import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/src/api/api_repo.dart';
import 'package:api_repo/src/local_api/src/local_api.dart';
import 'package:api_repo/src/user/src/models/user_forms_data.dart';
import 'package:background_location/services/notifications/forms_storage_service.dart';
import 'package:background_location/ui/cvd_form/models/chemical_use.dart';
import 'package:background_location/ui/cvd_form/models/cvd_form_data.dart';
import 'package:background_location/ui/cvd_form/models/product_integrity_details_model.dart';
import 'package:background_location/ui/cvd_form/models/transporter_details_model.dart';
import 'package:background_location/ui/cvd_form/widgets/form_stepper.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

import '../models/buyer_details_model.dart';
import '../models/commodity_details_model.dart';
import '../models/vendor_details_model.dart';

part 'cvd_state.dart';

class CvdCubit extends Cubit<CvdState> {
  final Api api;
  final LocalApi localApi;

  CvdCubit({required this.api, required this.localApi}) : super(const CvdState()) {
    // getCvdForm();
  }

  void init(BuildContext context) {
    _fetchVendorDetailsModel(context);
    _fetchBuyerDetailsModel(context);
    _fetchTransporterDetailsModel(context);
    _fetchCommodityDetailsModel(context);
    _fetchChemicalUseDetailsModel(context);
    _fetchPartIntegrityDetailsModel(context);
  }

  String? signature;

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
  final List<String> stepNames = [
    'Vendor Details',
    'Buyer Details',
    'Transporter',
    'Commodity Details',
    'Product Integrity',
    'Chemical Use',
    'Self Declaration'
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
    stepCompleted[(_step == 0 ? _step : _step - 1)] = true;
    emit(state.copyWith(currentStep: _step));
    moveToPage(_step);
  }

  void moveToPage(int page) {
    if (!stepCompleted[page - 1]) {
      return;
    }
    emit(state.copyWith(currentStep: page));
    pageController.animateToPage(
      page,
      curve: Curves.fastOutSlowIn,
      duration: 500.milliseconds,
    );
  }

  void getApiData() async {
    try {
      final result = await Dio().post(
        'https://uniquetowinggoa.com/safemeat/public/api/declaration',
        data: _cvdFormData,
        options: dio.Options(
          responseType: ResponseType.bytes,
        ),
        onReceiveProgress: (a, b) {
          print('$a $b');
        },
        onSendProgress: (a, b) {
          print('$a $b');
        },
      );

      final formsService = FormsStorageService();
      final file = await formsService.saveCvdForm(result.data);
      await OpenFile.open(file.path);

      // await Get.to(
      //   () => Scaffold(
      //     appBar: const MyAppBar(
      //       title: Text('CVD FORM PDF'),
      //     ),
      //     body: Image.memory(file.readAsBytesSync()),
      //   ),
      // );
    } catch (e) {
      print(e);
    }
  }

  Map<String, Object?> get _cvdFormData {
    return {
      'vendorName': vendorDetails.name!.value,
      'vendorAddress': vendorDetails.address!.value,
      'vendorTown': vendorDetails.town!.value,
      'vendorContact': vendorDetails.tel!.value,
      'vendorFax': vendorDetails.fax!.value,
      'vendorEmail': vendorDetails.email!.value,
      'vendorNGR': vendorDetails.ngr!.value,
      'vendorPIC': vendorDetails.pic!.value,
      'vendorRefrence': vendorDetails.refrenceNo!.value,
      'buyerName': buyerDetailsModel.name!.value,
      'buyerAddress': buyerDetailsModel.address!.value,
      'buyerTown': buyerDetailsModel.town!.value,
      'buyerContact': buyerDetailsModel.tel!.value,
      'buyerFax': buyerDetailsModel.fax!.value,
      'buyerEmail': buyerDetailsModel.email!.value,
      'buyerNGR': buyerDetailsModel.ngr!.value,
      'buyerPIC': buyerDetailsModel.pic!.value,
      'buyerRefrence': buyerDetailsModel.contractNo!.value,
      'commodity': commodityDetails.commodity!.value,
      // 'period': commodityDetails.deliveryPeriod!.value,
      'period': '30',
      // commodityDetails.deliveryPeriod!.value
      'variety1': commodityDetails.variety1!.value,
      'variety2': commodityDetails.variety2!.value,
      'quantity1': commodityDetails.quantity1!.value,
      'quantity2': commodityDetails.quantity2!.value,
      'sourceCheck': productIntegrityDetailsModel.sourceCheck?.value,
      'materialCheck': productIntegrityDetailsModel.materialCheck?.value,
      'gmoCheck': productIntegrityDetailsModel.gmoCheck?.value,
      'chemicalCheck': chemicalUseDetailsModel.chemicalCheck?.value,
      'chemicals': [
        {'chemicalName': 'chemical1', 'rate': '200', 'applicationDate': '2022-08-25', 'WHP': '456'},
        {'chemicalName': 'chemical2', 'rate': '2000', 'applicationDate': '2022-08-27', 'WHP': '753'},
        {'chemicalName': 'chemical3', 'rate': '2650', 'applicationDate': '2022-08-21', 'WHP': '1369'},
        {'chemicalName': 'chemical4', 'rate': '800', 'applicationDate': '2022-04-25', 'WHP': '789'}
      ],
      'qaCheck': chemicalUseDetailsModel.qaCheck?.value,
      'qaProgram': chemicalUseDetailsModel.qaProgram?.value,
      'certificateNumber': chemicalUseDetailsModel.certificateNumber?.value,
      'cvdCheck': chemicalUseDetailsModel.cvdCheck?.value,
      // 'cropList': [
      //   {'cropName': 'crop1'},
      //   {'cropName': 'crop2'},
      //   {'cropName': 'crop3'},
      //   {'cropName': 'crop4'}
      // ],
      'cropList': chemicalUseDetailsModel.cropList?.value!.split(',').map((e) => {'cropName': e}).toList(),
      'riskCheck': chemicalUseDetailsModel.riskCheck?.value,
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
}
