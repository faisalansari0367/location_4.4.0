import 'dart:io';

import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/services/notifications/forms_storage_service.dart';
import 'package:cvd_forms/cvd_forms.dart';
import 'package:cvd_forms/models/src/cvd_form.dart';
import 'package:flutter/material.dart';

class CvdRecordNotifier extends BaseModel {
  CvdRecordNotifier(BuildContext context) : super(context) {
    cvdFormsRepo = api;
    init();
    getLocalForms();
  }

  late CvdFormsRepo cvdFormsRepo;
  List<FileSystemEntity> _files = [];
  List<CvdForm> _forms = [];

  List<CvdForm> get forms => _forms;
  List<FileSystemEntity> get files => _files;

  DateTime getDateTime(FileSystemEntity file) {
    return DateTime.parse(file.path.split('CVD Form ').last);
  }

  void init() async {
    final forms = FormsStorageService(api);
    _files = await forms.getCvdForms();
    notifyListeners();
  }

  Future<void> getLocalForms() async {
    final result = cvdFormsRepo.getCvdForms();
    result.when(
      success: (data) {
        _forms = data;
        notifyListeners();
      },
      failure: (s) {},
    );
  }
}
