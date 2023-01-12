import 'package:api_repo/api_repo.dart';
import 'package:cvd_forms/cvd_forms.dart';
import 'package:flutter/material.dart';

enum UploadStatus {
  notUploaded,
  startingUpload,
  uploading,
  uploaded,
  failed,
}

abstract class UploadController implements ChangeNotifier {
  UploadStatus get uploadStatus;
  double get progress;

  void startUpload();
  void stopUpload();
  void finishUpload();
}

class SyncCvdController extends UploadController with ChangeNotifier {
  SyncCvdController({
    // UploadStatus uploadStatus = UploadStatus.notUploaded,
    // double progress = 0.0,
    required Api cvdFormsRepo,
  }) : _cvdFormsRepo = cvdFormsRepo;

  // final List<CvdForm> _forms;
  final CvdFormsRepo _cvdFormsRepo;
  double _progress = 0.0;
  int currentFile = 1;
  UploadStatus _uploadStatus = UploadStatus.notUploaded;

  int get totalFiles => _cvdFormsRepo.cvdForms.length;

  @override
  void finishUpload() {
    // TODO: implement finishUpload
  }

  @override
  // TODO: implement progress
  double get progress => _progress;

  @override
  Future<void> startUpload() async {
    _uploadStatus = UploadStatus.startingUpload;
    for (var i = 0; i < _cvdFormsRepo.cvdForms.length; i++) {
      final form = _cvdFormsRepo.cvdForms.elementAt(i);
      currentFile = i + 1;
      notifyListeners();
      _uploadStatus = UploadStatus.uploading;
      final result = await _cvdFormsRepo.uploadCvdForm(
        form,
        '',
        onSendProgress: _onSendProgress,
      );
      result.when(
        success: (value) {
          _uploadStatus = UploadStatus.uploaded;
          notifyListeners();
        },
        failure: (error) {
          _uploadStatus = UploadStatus.failed;
          notifyListeners();
        },
      );
    }
  }

  void _onSendProgress(int count, int total) {
    _progress = count / total;
    notifyListeners();
  }

  @override
  void stopUpload() {
    // TODO: implement stopUpload
  }

  @override
  UploadStatus get uploadStatus => _uploadStatus;
}
