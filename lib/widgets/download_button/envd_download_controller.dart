import 'dart:io';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/services/notifications/forms_storage_service.dart';
import 'package:background_location/widgets/download_button/download_controller.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class EnvdDownloadController extends DownloadController with ChangeNotifier {
  EnvdDownloadController({
    DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
    double progress = 0.0,
    required String downloadUrl,
    required String consignmentNo,
    required Api api,
    required VoidCallback onOpenDownload,
  })  : _downloadStatus = downloadStatus,
        _progress = progress,
        _api = api,
        _downloadUrl = downloadUrl,
        _consignmentNo = consignmentNo {
    _init();
  }

  final Api _api;
  late FormsStorageService _service;
  // final VoidCallback _onOpenDownload;
  double _progress;
  final String? _downloadUrl;
  final String? _consignmentNo;
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
  void startDownload() async {
    final service = FormsStorageService(_api);
    _downloadStatus = DownloadStatus.downloading;
    notifyListeners();
    final file = await service.saveEnvdPdf(_downloadUrl!, _consignmentNo!, onReceiveProgress: _onReceiveProgress);
    _downloadedFile = file;
    _downloadStatus = DownloadStatus.downloaded;
    notifyListeners();
  }

  @override
  void stopDownload() {}

  void _onReceiveProgress(int p1, int p2) {
    _progress = p1 / p2;
    notifyListeners();
  }

  void _init() async {
    _service = FormsStorageService(_api);
    _downloadedFile = await _service.checkEnvdInCache(_consignmentNo!);
    if (_downloadedFile != null) {
      _downloadStatus = DownloadStatus.downloaded;
      notifyListeners();
    }
  }
}
