import 'dart:developer';

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
    // required this.onUploadFinished,
  }) : _cvdFormsRepo = cvdFormsRepo;
  // _uploadStatus = uploadStatus;
  // _progress = progress;

  // final List<CvdForm> _forms;
  final CvdFormsRepo _cvdFormsRepo;
  double _progress = 0.0;
  int currentFile = 1;
  UploadStatus _uploadStatus = UploadStatus.notUploaded;
  VoidCallback? onUploadFinished;

  int get totalFiles => _cvdFormsRepo.cvdForms.length;

  @override
  void finishUpload() {
    // TODO: implement finishUpload
    _progress = 0.0;
    _uploadStatus = UploadStatus.uploaded;
    onUploadFinished?.call();
    notifyListeners();
  }

  void setOnFinished(VoidCallback onUploadFinished) {
    this.onUploadFinished = onUploadFinished;
  }

  @override
  // TODO: implement progress
  double get progress => _progress;

  @override
  Future<void> startUpload() async {
    if (_uploadStatus == UploadStatus.uploading) return;
    _uploadStatus = UploadStatus.startingUpload;
    _uploadStatus = UploadStatus.uploading;
    if (_cvdFormsRepo.cvdForms.isEmpty) {
      _uploadStatus = UploadStatus.notUploaded;
      notifyListeners();
      return;
    }
    notifyListeners();
    log('cvd forms to upload ${_cvdFormsRepo.cvdForms.length}');
    // final mockProgress = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
    // for (var i = 0; i < mockProgress.length; i++) {
    //   _progress = mockProgress[i];
    //   currentFile = i + 1;
    //   notifyListeners();
    //   await Future.delayed(const Duration(seconds: 1));
    // }

    // _uploadStatus = UploadStatus.uploaded;
    // finishUpload();
    for (var i = 0; i < _cvdFormsRepo.cvdForms.length; i++) {
      final form = _cvdFormsRepo.cvdForms.elementAt(i);
      log('cvd form to upload: ${form.fileName}');
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
          _cvdFormsRepo.deleteForm(form);
          finishUpload();
          // notifyListeners();
        },
        failure: (error) {
          _uploadStatus = UploadStatus.failed;
          _progress = 0.0;
          notifyListeners();
        },
      );
    }
  }

  void _onSendProgress(int count, int total) {
    _progress = count / total;
    log('uploading cvd files: $_progress');
    notifyListeners();
  }

  @override
  void stopUpload() {
    // TODO: implement stopUpload
  }

  @override
  UploadStatus get uploadStatus => _uploadStatus;
}
