// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/constans.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/ui/forms/models/global_form_model.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/dialogs/no_signature_found.dart';
import 'package:bioplus/widgets/signature/signature_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalQuestionnaireFormNotifier extends BaseModel {
  late FormQuestionDataModel model;
  bool selfDeclaration = false;
  final String zoneId;
  final int? logrecordId;

  GlobalQuestionnaireFormNotifier(super.context, {this.logrecordId, required this.zoneId}) {
    model = FormQuestionDataModel.fromLocal();
  }
  final formKey = GlobalKey<FormState>();
  final sc = ScrollController();

  Future<void> pickDateTime(QuestionData questionData, BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      // Navigator.pop(context);
      final time = await _timePicker(context);
      if (time != null) {
        final dt = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, time.hour, time.minute);
        questionData.value = dt.toIso8601String();
        notifyListeners();
      }
    }
  }

  Future<TimeOfDay?> _timePicker(BuildContext context) async {
    final pickedDate = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedDate != null) {
      return pickedDate;
    }
    return null;
  }

  void onChangeDecalration(bool value) {
    selfDeclaration = value;
    notifyListeners();
  }

  void onChangePeopleList(List<String> value) {
    model.userTravelingAlong = value;
    notifyListeners();
  }

  void onChanged(QuestionData questionData, dynamic value) {
    questionData.value = value;
    notifyListeners();
  }

  void scrollToEnd() {
    sc.animateTo(
      sc.position.maxScrollExtent,
      duration: kDuration,
      curve: kCurve,
    );
  }
  // void onChanged(QuestionData questionData, dynamic value) {
  //   questionData.value = value;
  //   notifyListeners();
  // }

  Future<void> submit() async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        // onSubmit(model.formData);
      }
      if (!selfDeclaration) {
        DialogService.error('Please accept the self declaration');
        return;
      }

      if (model.signature.value == null) {
        _noSignatureDialog();
        return;
      }
      final data = model.toJson();
      for (final element in data.entries) {
        if (element.value == null) {
          DialogService.error('Please fill Question ${model.question(element.key)}');
          return;
        }
      }
      await submitFormData(model.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> submitFormData(Map<String, dynamic> json) async {
    final result = await localApi.udpateForm(zoneId.toString(), json, logId: logrecordId);
    result.when(
      success: (data) {
        final msg = baseState.isConnected ? 'Form Submitted' : 'Form Saved Locally';
        DialogService.success(msg, onCancel: () => Get.close(2));
      },
      failure: (e) => DialogService.failure(error: e),
    );
  }

  Future<dynamic> _noSignatureDialog() {
    return DialogService.showDialog(
      child: NoSignatureFound(
        message: 'Please sign the declaration',
        buttonText: 'OK',
        onTap: () async {
          Get.back();
          Get.to(
            () => CreateSignature(
              onDone: (s) {
                model.signature.value = s;
                notifyListeners();
              },
            ),
          );
          // Get.back();
        },
      ),
    );
  }
}

class FormQuestionDataModel {
  final QuestionData arePeopleTravelingWith;
  List<String> userTravelingAlong = const [];
  final QuestionData isQfeverVaccinated;
  final QuestionData isFluSymptoms;
  final QuestionData isOverSeaVisit;
  final QuestionData isAllMeasureTaken;
  final QuestionData isOwnerNotified;
  final QuestionData rego;
  final QuestionData riskRating;
  // final QuestionData expectedDepartureTime;
  final QuestionData expectedDepartureDate;
  final QuestionData signature;
  final _model = GlobalDeclarationFormKeys();

  FormQuestionDataModel({
    required this.arePeopleTravelingWith,
    required this.userTravelingAlong,
    required this.isQfeverVaccinated,
    required this.isFluSymptoms,
    required this.isOverSeaVisit,
    required this.isAllMeasureTaken,
    required this.isOwnerNotified,
    required this.rego,
    required this.riskRating,
    // required this.expectedDepartureTime,
    required this.expectedDepartureDate,
    required this.signature,
  });

  String question(String key) => _model.question(key);

  factory FormQuestionDataModel.fromLocal() {
    final model = GlobalDeclarationFormKeys();
    final question = model.question;

    return FormQuestionDataModel(
      userTravelingAlong: [],
      arePeopleTravelingWith: QuestionData<bool>(
        question: question(model.isPeopleTravelingWith),
        key: model.isPeopleTravelingWith,
      ),
      isQfeverVaccinated: QuestionData<bool>(
        question: question(model.isQfeverVaccinated),
        key: model.isQfeverVaccinated,
      ),
      isFluSymptoms: QuestionData<bool>(
        question: question(model.isFluSymptoms),
        key: model.isFluSymptoms,
      ),
      isOverSeaVisit: QuestionData<bool>(
        question: question(model.isOverSeaVisit),
        key: model.isOverSeaVisit,
      ),
      isAllMeasureTaken: QuestionData<bool>(
        question: question(model.isAllMeasureTaken),
        key: model.isAllMeasureTaken,
      ),
      isOwnerNotified: QuestionData<bool>(
        question: question(model.isOwnerNotified),
        key: model.isOwnerNotified,
      ),
      rego: QuestionData<String>(
        question: question(model.rego),
        key: model.rego,
      ),
      riskRating: QuestionData<String>(
        question: question(model.riskRating),
        key: model.riskRating,
        value: 'LOW',
      ),
      // expectedDepartureTime: QuestionData<String>(
      //   question: question(model.expectedDepartureTime),
      //   key: model.expectedDepartureTime,
      // ),
      expectedDepartureDate: QuestionData<String>(
        question: question(model.expectedDepartureDate),
        key: model.expectedDepartureDate,
        value: DateTime.now().toIso8601String(),
      ),
      signature: QuestionData<String>(
        question: question(model.signature),
        key: model.signature,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final model = GlobalDeclarationFormKeys();
    final map = {};
    map[arePeopleTravelingWith.key] = arePeopleTravelingWith.value;
    if (userTravelingAlong.isNotEmpty) {
      map[model.userTravelingAlong] = userTravelingAlong;
    }
    map[isQfeverVaccinated.key] = isQfeverVaccinated.value;
    map[isFluSymptoms.key] = isFluSymptoms.value;
    map[isOverSeaVisit.key] = isOverSeaVisit.value;
    map[isAllMeasureTaken.key] = isAllMeasureTaken.value;
    map[isOwnerNotified.key] = isOwnerNotified.value;
    map[rego.key] = rego.value;
    map[riskRating.key] = riskRating.value;
    // map[expectedDepartureTime.key] = expectedDepartureTime.value;
    map[expectedDepartureDate.key] = expectedDepartureDate.value;
    map[signature.key] = signature.value;
    return Map<String, dynamic>.from(map);
  }
}
