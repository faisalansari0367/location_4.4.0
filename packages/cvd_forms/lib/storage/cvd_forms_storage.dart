import 'package:hive_flutter/hive_flutter.dart';

import '../models/src/cvd_form.dart';

abstract class _Keys {
  static const cvdForm = 'cvdForm';
  static const currentForm = 'currentForm';
}

class CvdFormsStorage {
  final Box box;

  CvdFormsStorage(this.box);

  Future<void> addCvdForm(CvdForm cvdForm) async {
    final data = getCvdForms();
    data.add(cvdForm);
    final json = data.map((e) => e.toJson()).toList();
    await box.put(_Keys.cvdForm, json);
  }

  List<CvdForm> getCvdForms() {
    final data = box.get(_Keys.cvdForm, defaultValue: []);
    return data.map<CvdForm>((e) => CvdForm.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<bool> deleteCvdForm(CvdForm cvdForm) async {
    bool result = false;
    try {
      final data = getCvdForms();
      data.remove(cvdForm);
      final json = data.map((e) => e.toJson()).toList();
      await box.put(_Keys.cvdForm, json);
      result = true;
    } on Exception {
      result = false;
    }
    return result;
  }

  Future<CvdForm> updateCvdForm(CvdForm cvdForm) async {
    try {
      await box.put(_Keys.currentForm, cvdForm.toJson());
      return cvdForm;
    } on Exception {
      rethrow;
    }
  }

  CvdForm? getCvdForm() {
    try {
      final result = box.get(_Keys.currentForm);
      if (result == null) {
        return null;
      }
      return CvdForm.fromJson(Map<String, dynamic>.from(result));
    } on Exception {
      rethrow;
    }
  }
}
