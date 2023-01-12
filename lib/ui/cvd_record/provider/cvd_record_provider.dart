import 'dart:io';

import 'package:bioplus/provider/base_model.dart';
import 'package:cvd_forms/cvd_forms.dart';

class CvdRecordNotifier extends BaseModel {
  CvdRecordNotifier(super.context) {
    cvdFormsRepo = api;
    init();
    // getLocalForms();
  }

  late CvdFormsRepo cvdFormsRepo;
  final List<FileSystemEntity> _files = [];
  List<CvdForm> _forms = [];

  List<CvdForm> get forms => cvdFormsRepo.cvdForms;
  List<FileSystemEntity> get files => _files;

  // DateTime getDateTime(FileSystemEntity file) {
  //   return DateTime.parse(file.path.split('CVD Form ').last);
  // }

  Future<void> init() async {
    // final forms = FormsStorageService(api);
    // _files = await forms.getCvdForms();
    // _files.sort(_sortByDateAdded);
    // notifyListeners();
    _listen();
  }

  // int _sortByDateAdded(DateTime a, DateTime b) => b.compareTo(a);
  int _sortCvdForms(CvdForm a, CvdForm b) =>
      b.createdAt!.compareTo(a.createdAt!);

  Future<void> uploadForm(CvdForm form) async {
    final newFOrm = form.copyWith(pic: api.getUserData()?.pic);
    await api.uploadCvdForm(newFOrm, api.getUserData()?.pic);
  }

  Future<void> deleteForm(CvdForm form) async {
    await cvdFormsRepo.deleteForm(form);
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

  Future<void> _listen() async =>
      cvdFormsRepo.cvdFormsStream.listen((event) {
        
        notifyListeners();
      });
}
