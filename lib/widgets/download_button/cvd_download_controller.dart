import 'dart:io';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/download_button/download_controller.dart';
import 'package:cvd_forms/cvd_forms.dart';
import 'package:flutter/material.dart';
import 'package:open_file_safe/open_file_safe.dart';
// import 'path:path.dart';

class CvdDownloadController extends DownloadController with ChangeNotifier {
  CvdDownloadController({
    DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
    double progress = 0.0,
    required CvdModel form,
    required CvdFormsRepo cvdFormsRepo,
  })  : _downloadStatus = downloadStatus,
        _progress = progress,
        cvdForm = form,
        _cvdFormsRepo = cvdFormsRepo {
    _init();
  }

  final CvdFormsRepo _cvdFormsRepo;
  final CvdModel cvdForm;
  // late final FormsStorageService _service;

  // final VoidCallback _onOpenDownload;
  double _progress;

  DownloadStatus _downloadStatus;

  File? downloadedFile;

  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  @override
  void openDownload() {
    if (downloadedFile != null) {
      OpenFile.open(downloadedFile!.path);
    }
  }

  @override
  double get progress => _progress;

  @override
  Future<void> startDownload() async {
    // await Permission.storage.request();
    _downloadStatus = DownloadStatus.downloading;
    notifyListeners();
    final result = await _cvdFormsRepo.saveOnlineCvd(
      cvdForm,
      onReceiveProgress: _onReceiveProgress,
    );
    result.when(success: success, failure: failure);
  }

  @override
  void stopDownload() {}

  void _onReceiveProgress(int p1, int p2) {
    _progress = p1 / p2;
    notifyListeners();
  }

  Future<void> _init() async {
    final dir = await _cvdFormsRepo.getCvdDownloadsDir();
    final files = await dir.list().toList();
    final foundFiles = files.where(
      (element) {
        final string =
            element.path.substring(dir.path.length + 1, element.path.length);
        final fileName = cvdForm.pdfUrl!.split('/').last;
        return string.startsWith(fileName);
      },
    );
    if (foundFiles.isNotEmpty && foundFiles.length == 1) {
      downloadedFile = foundFiles.first as File;
      _downloadStatus = DownloadStatus.downloaded;
      notifyListeners();
    }
  }

  Future<void> failure(NetworkExceptions error) async {
    // if (error is NoInternetConnection) {
    //   // _saveFormLocally();
    //   return;
    // }
    DialogService.failure(error: error);
    _downloadStatus = DownloadStatus.notDownloaded;
    notifyListeners();
    return;
  }

  Future<void> success(File data) async {
    downloadedFile = data;
    _downloadStatus = DownloadStatus.downloaded;
    // openDownload();
    notifyListeners();
  }

  // Future<void> _saveFormLocally() async {
  // final result = await _cvdFormsRepo.addCvdForm(cvdForm);
  // result.when(
  //   success: (data) async {
  //     _downloadStatus = DownloadStatus.downloaded;
  //     _progress = 100.0;
  //     notifyListeners();
  //     DialogService.success(
  //       'Form is saved locally and will automatically update to the server when internet service is available.',
  //       onCancel: Get.back,
  //     );
  //   },
  //   failure: (e) {
  //     DialogService.failure(error: e);
  //     _downloadStatus = DownloadStatus.notDownloaded;
  //     notifyListeners();
  //   },
  // );
  // }
}
