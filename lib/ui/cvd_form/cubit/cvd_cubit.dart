import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/widgets/download_button/cvd_download_controller.dart';
import 'package:cvd_forms/cvd_forms.dart';
import 'package:cvd_forms/models/src/cvd_form.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file/open_file.dart';

import '../../../services/notifications/forms_storage_service.dart';
import '../../../widgets/dialogs/dialog_service.dart';

part 'cvd_state.dart';

class CvdCubit extends Cubit<CvdState> {
  final Api api;
  final LocalApi localApi;
  late Box _box;
  late CvdForm cvdForm;
  late CvdFormsRepo cvdFormsRepo;

  CvdCubit({required this.api, required this.localApi}) : super(const CvdState()) {
    // getCvdForm();
  }

  void init(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    cvdFormsRepo = context.read<Api>();

    final _cvdForm = cvdFormsRepo.getCurrentForm();
    if (_cvdForm != null) {
      cvdForm = _cvdForm;
    } else {
      cvdForm = await CvdForm.init(context);
    }
    emit(state.copyWith(isLoading: false));
    // final futures = [
    //   _fetchVendorDetailsModel(context),
    //   _fetchBuyerDetailsModel(context),
    //   _fetchTransporterDetailsModel(context),
    //   _fetchCommodityDetailsModel(context),
    //   _fetchChemicalUseDetailsModel(context),
    //   _fetchPartIntegrityDetailsModel(context),
    // ];
    // await Future.wait(futures);
    // final formData
    // _fromJson();
    // emit(state.copyWith(isLoading: false));
  }

  // String? signature, organisationName;
  // String riskAssesment = '';
  // String testResults = '';

  VendorDetailsModel get vendorDetailsModel => cvdForm.vendorDetails!;
  BuyerDetailsModel get buyerDetailsModel => cvdForm.buyerDetailsModel!;
  TransporterDetailsModel get transporterDetailsModel => cvdForm.transporterDetails!;
  CommodityDetailsModel get commodityDetailsModel => cvdForm.commodityDetails!;
  ChemicalUseDetailsModel get chemicalUseDetailsModel => cvdForm.chemicalUseDetailsModel!;
  ProductIntegrityDetailsModel get productIntegrityDetailsModel => cvdForm.productIntegrityDetailsModel!;
  String get testResults => cvdForm.testResult ?? '';
  String get riskAssesment => cvdForm.riskAssesment ?? '';
  String? get signature => cvdForm.signature;


  // String signature = '';
  // CvdFormData get cvdFormData => cvdForm.cvdFormData!;

  // VendorDetailsModel vendorDetails = VendorDetailsModel();
  // BuyerDetailsModel buyerDetailsModel = BuyerDetailsModel();
  // TransporterDetailsModel transporterDetails = TransporterDetailsModel();
  // CommodityDetailsModel commodityDetails = CommodityDetailsModel();
  // ChemicalUseDetailsModel chemicalUseDetailsModel = ChemicalUseDetailsModel();
  // ProductIntegrityDetailsModel productIntegrityDetailsModel = ProductIntegrityDetailsModel();

  // Future<void> _fetchVendorDetailsModel(BuildContext context) async {
  //   emit(state.copyWith(isLoading: true));
  //   final data = await DefaultAssetBundle.of(context).loadString('assets/json/vendor_details.json');
  //   final map = jsonDecode(data);
  //   vendorDetails = VendorDetailsModel.fromJson(map);
  //   emit(state.copyWith(isLoading: false));
  // }

  // Future<void> _fetchBuyerDetailsModel(BuildContext context) async {
  //   emit(state.copyWith(isLoading: true));
  //   final data = await DefaultAssetBundle.of(context).loadString('assets/json/buyer_details.json');
  //   final map = jsonDecode(data);
  //   buyerDetailsModel = BuyerDetailsModel.fromJson(map);
  //   emit(state.copyWith(isLoading: false));
  // }

  // Future<void> _fetchTransporterDetailsModel(BuildContext context) async {
  //   emit(state.copyWith(isLoading: true));
  //   final data = await DefaultAssetBundle.of(context).loadString('assets/json/transporter_details.json');
  //   final map = jsonDecode(data);
  //   transporterDetails = TransporterDetailsModel.fromJson(map);
  //   emit(state.copyWith(isLoading: false));
  // }

  // Future<void> _fetchCommodityDetailsModel(BuildContext context) async {
  //   emit(state.copyWith(isLoading: true));
  //   final data = await DefaultAssetBundle.of(context).loadString('assets/json/commodity_details.json');
  //   final map = jsonDecode(data);
  //   commodityDetails = CommodityDetailsModel.fromJson(map);
  //   emit(state.copyWith(isLoading: false));
  // }

  // Future<void> _fetchChemicalUseDetailsModel(BuildContext context) async {
  //   emit(state.copyWith(isLoading: true));
  //   final data = await DefaultAssetBundle.of(context).loadString('assets/json/chemical_use.json');
  //   final map = jsonDecode(data);
  //   chemicalUseDetailsModel = ChemicalUseDetailsModel.fromJson(map);
  //   emit(state.copyWith(isLoading: false));
  // }

  // Future<void> _fetchPartIntegrityDetailsModel(BuildContext context) async {
  //   emit(state.copyWith(isLoading: true));
  //   final data = await DefaultAssetBundle.of(context).loadString('assets/json/part_integrity_form.json');
  //   final map = jsonDecode(data);
  //   productIntegrityDetailsModel = ProductIntegrityDetailsModel.fromJson(map['data']);
  //   emit(state.copyWith(isLoading: false));
  // }

  void setBuyerDetails(BuyerDetailsModel model) {
    cvdForm.buyerDetailsModel = model;
    emit(state.copyWith());
  }

  void setTransporterDetails(TransporterDetailsModel model) {
    cvdForm.transporterDetails = model;
    emit(state.copyWith());
  }

  void setVendorDetails(VendorDetailsModel model) {
    cvdForm.vendorDetails = model;
    emit(state.copyWith());
  }

  void setChemicalDetails(ChemicalUseDetailsModel model) {
    cvdForm.chemicalUseDetailsModel = model;
    emit(state.copyWith());
  }

  void setCommodityDetails(CommodityDetailsModel model) {
    cvdForm.commodityDetails = model;
    emit(state.copyWith());
  }

  void setProductIntegrityDetails(ProductIntegrityDetailsModel model) {
    cvdForm.productIntegrityDetailsModel = model;
    emit(state.copyWith());
  }

  void setRiskAssesment(String value) {
    cvdForm.riskAssesment = value;
    emit(state.copyWith());
  }

  void setTestResults(String value) {
    cvdForm.testResult = value;
    emit(state.copyWith());
  }

  void setSignature(String value) {
    cvdForm.signature = value;
    emit(state.copyWith());
  }

  void setOrgName(String value) {
    cvdForm.organisationName = value;
    emit(state.copyWith());
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
      curve: kCurve,
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

  Future<void> saveFormData() async => await cvdFormsRepo.updateCvdForm(cvdForm);

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
        curve: kCurve,
      );
    }

    emit(state.copyWith(currentStep: page));
    pageController.animateToPage(
      page,
      curve: kCurve,
      duration: 500.milliseconds,
    );
  }

  Future<void> submitForm() async {
    final result = await cvdFormsRepo.submitForm(cvdForm);
    result.when(
      success: (data) async {
        final formsService = FormsStorageService(api);
        final file = await formsService.saveCvdForm(data, cvdForm.buyerDetailsModel?.name?.value ?? '');
        OpenFile.open(file.path);
        Get.close(2);
      },
      failure: (e) async {
        if (e is NoInternetConnection) {
          _saveFormLocally();
          return;
        }
        DialogService.failure(error: e);
      },
    );

    // emit(state.copyWith(isLoading: true));
    // try {
    //   final result = await Dio().post(
    //     'https://uniquetowinggoa.com/safemeat/public/api/declaration',
    //     data: _cvdFormData,
    //   );
    //   if (result.data['status'] == false) {
    //     final error = result.data['data'] as Map;
    //     DialogService.error('${result.data['message']} \n ${error.values.first}');
    //     return;
    //   }

    //   final formsService = FormsStorageService(api);
    //   final bytes = base64Decode(result.data['data']);
    //   final file = await formsService.saveCvdForm(bytes, buyerDetailsModel.name?.value ?? '');
    //   await OpenFile.open(file.path);
    //   Get.close(2);
    // } on DioError catch (e) {
    //   if (e.error is SocketException) {
    //     // final json = _toJson();
    //     // await saveCvdForm(json);
    //     DialogService.error(
    //         'Form is saved locally and will automatically update to the server when internet service is available.');
    //   } else {
    //     DialogService.error('Something went wrong');
    //   }
    //   // print(e);
    // }
    // emit(state.copyWith(isLoading: false));
  }

  Map<String, Object?> get _cvdFormData {
    return {
      // return {
      //   'vendorName': vendorDetails.name!.value,
      //   'vendorAddress': vendorDetails.address!.value,
      //   'vendorTown': vendorDetails.town!.value,
      //   'vendorContact': (vendorDetails.tel!.value),
      //   'vendorFax': vendorDetails.fax!.value,
      //   'vendorEmail': vendorDetails.email!.value,
      //   'vendorNGR': vendorDetails.ngr!.value,
      //   'vendorPIC': vendorDetails.pic!.value,
      //   'vendorReference': vendorDetails.refrenceNo!.value,
      //   'buyerName': buyerDetailsModel.name!.value,
      //   'buyerAddress': buyerDetailsModel.address!.value,
      //   'buyerTown': buyerDetailsModel.town!.value,
      //   'buyerContact': buyerDetailsModel.tel!.value,
      //   'buyerFax': buyerDetailsModel.fax!.value,
      //   'buyerEmail': buyerDetailsModel.email!.value,
      //   'buyerNGR': buyerDetailsModel.ngr!.value,
      //   'buyerPIC': buyerDetailsModel.pic!.value,
      //   'buyerReference': buyerDetailsModel.contractNo!.value,
      //   'driverName': transporterDetails.name?.value,
      //   'driverEmail': transporterDetails.email?.value,
      //   'driverContact': transporterDetails.mobile?.value,
      //   'companyName': transporterDetails.company?.value,
      //   'registration': transporterDetails.registration?.value,
      //   'commodity': commodityDetails.commodity!.value,
      //   'period': MyDecoration.formatDate(DateTime.tryParse(commodityDetails.deliveryPeriod!.value!)),
      //   'variety1': commodityDetails.variety1!.value,
      //   'variety2': commodityDetails.variety2!.value,
      //   'quantity1': commodityDetails.quantity1!.value,
      //   'quantity2': commodityDetails.quantity2!.value,
      //   'sourceCheck': productIntegrityDetailsModel.sourceCheck?.value,
      //   'materialCheck': productIntegrityDetailsModel.materialCheck?.value,
      //   'gmoCheck': productIntegrityDetailsModel.gmoCheck?.value,
      //   'chemicalCheck': chemicalUseDetailsModel.chemicalCheck?.value,
      //   'chemicals': chemicalUseDetailsModel.chemicalTable.map((e) => e.toJson()).toList(),
      //   'qaCheck': chemicalUseDetailsModel.qaCheck?.value,
      //   'qaProgram': chemicalUseDetailsModel.qaProgram?.value,
      //   'certificateNumber': chemicalUseDetailsModel.certificateNumber?.value,
      //   'cvdCheck': chemicalUseDetailsModel.cvdCheck?.value,
      //   'organisationName': organisationName,
      //   'riskAssesment': riskAssesment,
      //   'testResult': testResults,
      //   'cropList': chemicalUseDetailsModel.cropList?.value == null
      //       ? []
      //       : chemicalUseDetailsModel.cropList?.value!.split(',').map((e) => {'cropName': e}).toList(),
      //   'riskCheck': chemicalUseDetailsModel.riskCheck?.value,
      //   // 'organisationName':
      //   'nataCheck': chemicalUseDetailsModel.nataCheck?.value,
      //   'signature': signature,
      // };
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

  void toggleOfflineForms() {
    emit(state.copyWith(showOfflineForms: !state.showOfflineForms));
  }

  void success(UserFormsData data) {
    emit(state.copyWith(forms: data.data?.forms));
    // data.data.forms;
  }

  // Map<String, Map<String, dynamic>> _toJson() {
  //   final json = {
  //     'vendorDetails': vendorDetails.toJson(),
  //     'buyerDetailsModel': buyerDetailsModel.toJson(),
  //     'transporterDetails': transporterDetails.toJson(),
  //     'commodityDetails': commodityDetails.toJson(),
  //     'chemicalUseDetailsModel': chemicalUseDetailsModel.toJson(),
  //     'productIntegrityDetailsModel': productIntegrityDetailsModel.toJson(),
  //   };
  //   // _box.put('json', json);
  //   // await saveCvdForm(json);
  //   return json;
  // }

  // void _fromJson(Map<String, dynamic>? json) {
  //   if (json == null) return;
  //   if (json['vendorDetails'] != null) vendorDetails = VendorDetailsModel.fromJson(json['vendorDetails']);
  //   // vendorDetails = VendorDetailsModel.fromJson(json['venderDetails'] );
  //   if (json['buyerDetailsModel'] != null) buyerDetailsModel = BuyerDetailsModel.fromJson(json['buyerDetailsModel']);
  //   if (json['transporterDetails'] != null)
  //     transporterDetails = TransporterDetailsModel.fromJson(json['transporterDetails']);
  //   if (json['commodityDetails'] != null) commodityDetails = CommodityDetailsModel.fromJson(json['commodityDetails']);
  //   if (json['chemicalUseDetailsModel'] != null)
  //     chemicalUseDetailsModel = ChemicalUseDetailsModel.fromJson(json['chemicalUseDetailsModel']);
  //   if (json['productIntegrityDetailsModel'] != null)
  //     productIntegrityDetailsModel = ProductIntegrityDetailsModel.fromJson(json['productIntegrityDetailsModel']);
  // }

  Future<void> saveCvdForm(Map<String, Map<String, dynamic>> json) async {
    try {
      final cvdOfflineForms = await getCvdForms();
      cvdOfflineForms.add(json);
      await _box.put('cvdOfflineForms', cvdOfflineForms);
    } on Exception {
      rethrow;
    }
  }

  Future<List<Map<String, Map<String, dynamic>>>> getCvdForms() async {
    try {
      final cvdOfflineForms = _box.get('cvdOfflineForms') ?? [];
      return List<Map<String, Map<String, dynamic>>>.from(cvdOfflineForms);
    } on Exception {
      rethrow;
    }
  }

  Future<void> _saveFormLocally() async {
    final result = await cvdFormsRepo.addCvdForm(cvdForm);
    result.when(
      success: (data) async {
        DialogService.success(
          'Form is saved locally and will automatically update to the server when internet service is available.',
          onCancel: Get.back,
        );
      },
      failure: (e) {
        DialogService.failure(error: e);
      },
    );
  }
}
