import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:cvd_forms/cvd_forms.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:permission_handler/permission_handler.dart';

part 'cvd_state.dart';

class CvdCubit extends Cubit<CvdState> {
  final Api api;
  final LocalApi localApi;
  late Box _box;
  late CvdForm cvdForm;
  late CvdFormsRepo cvdFormsRepo;

  CvdCubit({required this.api, required this.localApi})
      : super(const CvdState()) {
    // getCvdForm();
  }

  Future<void> init(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    cvdFormsRepo = context.read<Api>();

    final CvdForm? currentForm = cvdFormsRepo.getCurrentForm();
    cvdForm = currentForm ?? await CvdForm.init(context);

    emit(state.copyWith(isLoading: false));
    listenToScrollPosition();
  }

  VendorDetailsModel get vendorDetailsModel => cvdForm.vendorDetails!;
  BuyerDetailsModel get buyerDetailsModel => cvdForm.buyerDetailsModel!;
  TransporterDetailsModel get transporterDetailsModel =>
      cvdForm.transporterDetails!;
  CommodityDetailsModel get commodityDetailsModel => cvdForm.commodityDetails!;
  ChemicalUseDetailsModel get chemicalUseDetailsModel =>
      cvdForm.chemicalUseDetailsModel!;
  ProductIntegrityDetailsModel get productIntegrityDetailsModel =>
      cvdForm.productIntegrityDetailsModel!;
  String get testResults => cvdForm.testResult ?? '';
  String get riskAssesment => cvdForm.riskAssesment ?? '';
  String? get signature => cvdForm.signature;

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
    false
  ];

  void changeCurrent(
    int currentStep, {
    bool isNext = false,
    bool isPrevious = false,
  }) {
    late int step = currentStep;

    if (isNext) {
      step = state.currentStep + 1;
    } else if (isPrevious) {
      step = state.currentStep - 1;
    }
    stepCompleted[step] = true;
    emit(state.copyWith(currentStep: step));
    moveToPage(step);
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
      centerStep(page);
    }
  }

  Future<void> centerStep(int step) {
    // final stepSize = stepController.position.maxScrollExtent / 2;
    // final currentScrollExtent = stepController.offset;

    return stepController.animateTo(
      100.0 * step,
      duration: const Duration(milliseconds: 500),
      curve: kCurve,
    );
  }

  void listenToScrollPosition() {
    // stepController.addListener(() {
    //   print(stepController.offset);
    // });
  }

  Future<void> saveFormData() async =>
       cvdFormsRepo.updateCvdForm(cvdForm);

  void moveToPage(int page) {
    if (page != 0) {
      if (!stepCompleted[page - 1]) {
        return;
      }
    }
    if (page > 1) {
      centerStep(page);
    }

    emit(state.copyWith(currentStep: page));
    pageController.animateToPage(
      page,
      curve: kCurve,
      duration: 500.milliseconds,
    );
  }

  Future<void> submitForm() async {
    final permission = await Permission.storage.request();
    if (!permission.isGranted) {
      DialogService.error(
        'Storage permission is required to save the form',
      );
      return;
    }

    final result = await cvdFormsRepo.submitCvdForm(cvdForm);
    result.when(
      success: (data) async {
        // final formsService = FormsStorageService(api);
        // final file = await formsService.saveCvdForm(
        //   data,
        //   cvdForm.buyerDetailsModel?.name?.value ?? '',
        // );
        // cvdFormsRepo.addCvdForm(cvdForm.copyWith(filePath: file.path));
        await OpenFile.open(data.path);
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
