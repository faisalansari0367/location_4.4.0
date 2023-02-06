import 'package:api_repo/api_repo.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/ui/forms/models/global_form_model.dart';
import 'package:bioplus/ui/forms/warakirri_entry_form/models/warakirri_form_model.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarakirriEntryFormNotifier extends BaseModel {
  final String zoneId;
  final PolygonModel? polygon;
  final int? logrecordId;
  late UserData? userData;
  late WarakirriFormModel model;
  WarakirriEntryFormNotifier(
    super.context, {
    this.polygon,
    required this.zoneId,
    this.logrecordId,
  }) {
    model = WarakirriFormModel.fromLocal();
    userData = api.getUserData();
    getFarmName();
  }
  bool _selfDeclaration = false;
  final formKey = GlobalKey<FormState>();

  final warakirriFarms = [
    'Coradjil Place',
    'Glenfarm',
    'Poorinda',
    'Welbourne'
  ];

  final decalations = [
    'All incidents, hazards or near miss events must be reported to a Warakirri representative',
    'observe and obeying all safety signs',
    'following all directions as provided by Warakirri representatives',
    'advising the Farm Manager or Assistant Manager when I leave the site',
    'I acknowledge the points indicated in the farm check-in. All points have been explained and are understood',
  ];

  bool get selfDeclaration => _selfDeclaration;

  void onChangeSelfDeclaration(bool value) {
    _selfDeclaration = value;
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

  Future<void> getFarmName() async {
    // final result = await apiService.getLogRecord(zoneId);
    // final name = result?.geofence?.name;
    // if (name != null) {
    model.warakirriFarm.value = polygon?.name ?? '';
    notifyListeners();
    // }
  }

  Future<void> pickDateTime(
    QuestionData questionData,
    BuildContext context,
  ) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      // Navigator.pop(context);
      // ignore: use_build_context_synchronously
      final time = await _timePicker(context);
      if (time != null) {
        final dt = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          time.hour,
          time.minute,
        );
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

  Future<void> submit() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      if (!_selfDeclaration) {
        DialogService.error('Please accept the conditions');
        return;
      }

      final data = model.toJson();
      for (final element in data.entries) {
        if (element.value == null) {
          DialogService.error(
            'Please fill the field ${model.question(element.key)}',
          );
          return;
        }
      }
      data['type'] = DeclarationFormType.warakirri.name;
      final result =
          await localApi.udpateForm(zoneId, logId: logrecordId, data);
      result.when(
        success: success,
        failure: failure,
      );
    } on Exception {
      rethrow;
    }
  }

  void onChangeDecalration(bool? value) {
    _selfDeclaration = value ?? false;
    notifyListeners();
  }

  Object? success(LogbookEntry data) {
    DialogService.success(
      'Form submitted successfully',
      onCancel: () => Get.close(2),
    );
    return null;
  }

  Object? failure(NetworkExceptions error) {
    DialogService.failure(error: error);
    return null;
  }
}
