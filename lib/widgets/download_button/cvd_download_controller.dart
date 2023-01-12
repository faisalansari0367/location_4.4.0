import 'dart:io';
import 'dart:typed_data';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/services/notifications/forms_storage_service.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/download_button/download_controller.dart';
import 'package:cvd_forms/cvd_forms.dart';
import 'package:cvd_forms/models/src/cvd_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file_safe/open_file_safe.dart';

class CvdDownloadController extends DownloadController with ChangeNotifier {
  CvdDownloadController({
    DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
    double progress = 0.0,
    required CvdForm form,
    required CvdFormsRepo cvdFormsRepo,
    required Api api,
  })  : _downloadStatus = downloadStatus,
        _progress = progress,
        cvdForm = form,
        _cvdFormsRepo = cvdFormsRepo,
        _service = FormsStorageService(api);

  final CvdFormsRepo _cvdFormsRepo;
  final CvdForm cvdForm;
  late final FormsStorageService _service;

  // final VoidCallback _onOpenDownload;
  double _progress;

  DownloadStatus _downloadStatus;

  File? _downloadedFile;

  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  @override
  void openDownload() {
    if (_downloadedFile != null) {
      OpenFile.open(_downloadedFile!.path);
    }
  }

  @override
  double get progress => _progress;

  @override
  Future<void> startDownload() async {
    _downloadStatus = DownloadStatus.downloading;
    notifyListeners();
    final result = await _cvdFormsRepo.submitCvdForm(cvdForm,
        onReceiveProgress: _onReceiveProgress);
    result.when(success: success, failure: failure);

    // _downloadStatus = DownloadStatus.downloaded;
    // notifyListeners();
  }

  @override
  void stopDownload() {}

  void _onReceiveProgress(int p1, int p2) {
    _progress = p1 / p2;
    notifyListeners();
  }

  Future<void> _init() async {
    // _downloadedFile = await _service.checkEnvdInCache(_consignmentNo!);
    // if (_downloadedFile != null) {
    //   _downloadStatus = DownloadStatus.downloaded;
    //   notifyListeners();
    // }
  }

  Future<void> failure(NetworkExceptions error) async {
    if (error is NoInternetConnection) {
      _saveFormLocally();
      return;
    }
    DialogService.failure(error: error);
    _downloadStatus = DownloadStatus.notDownloaded;
    notifyListeners();
    return;
  }

  Future<void> success(File data) async {
    // _downloadedFile = await _service.saveCvdForm(
    //     data, cvdForm.buyerDetailsModel?.name?.value ?? '');
    // _downloadStatus = DownloadStatus.downloaded;
    // notifyListeners();
  }

  Future<void> _saveFormLocally() async {
    final result = await _cvdFormsRepo.addCvdForm(cvdForm);
    result.when(
      success: (data) async {
        _downloadStatus = DownloadStatus.downloaded;
        _progress = 100.0;
        notifyListeners();
        DialogService.success(
          'Form is saved locally and will automatically update to the server when internet service is available.',
          onCancel: Get.back,
        );
      },
      failure: (e) {
        DialogService.failure(error: e);
        _downloadStatus = DownloadStatus.notDownloaded;
        notifyListeners();
      },
    );
  }
}
