import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/subjects.dart';

import '../models/src/cvd_form.dart';

abstract class _Keys {
  static const cvdForm = 'cvdForm';
  static const currentForm = 'currentForm';
}

class CvdFormsStorage {
  final Box box;

  CvdFormsStorage(this.box) {
    _controller.add(getCvdForms());
    _listen();
  }

  final _controller = BehaviorSubject<List<CvdForm>>.seeded([]);

  Future<void> addCvdForm(CvdForm cvdForm) async {
    final data = getCvdForms();
    data.add(cvdForm);
    final json = data.map((e) => e.toJson()).toList();
    await box.put(_Keys.cvdForm, json);
  }

  List<CvdForm> getCvdForms({dynamic list}) {
    final data = list ?? box.get(_Keys.cvdForm, defaultValue: []);
    return data
        .map<CvdForm>((e) => CvdForm.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<bool> deleteCvdForm(CvdForm cvdForm) async {
    try {
      final data = getCvdForms();
      data.removeWhere((element) => element.filePath == cvdForm.filePath);
      final json = data.map((e) => e.toJson()).toList();
      await box.put(_Keys.cvdForm, json);
      return true;
    } on Exception {
      return false;
    }
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

  Stream<List<CvdForm>> get cvdFormsStream => _controller.stream;
  List<CvdForm> get cvdForms =>
      _controller.value..sort((b, a) => b.createdAt!.compareTo(a.createdAt!));

  void _listen() {
    box.watch(key: _Keys.cvdForm).listen((event) {
      _controller.add(getCvdForms(list: event.value));
    });
  }

  void dispose() {
    _controller.close();
  }
}
