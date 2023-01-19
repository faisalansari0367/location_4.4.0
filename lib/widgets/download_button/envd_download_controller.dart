import 'dart:io';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/services/notifications/forms_storage_service.dart';
import 'package:bioplus/widgets/download_button/download_controller.dart';
import 'package:flutter/material.dart';
import 'package:open_file_safe/open_file_safe.dart';

class EnvdDownloadController extends DownloadController with ChangeNotifier {
  EnvdDownloadController({
    DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
    double progress = 0.0,
    required String downloadUrl,
    required String consignmentNo,
    required Api api,
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
  Future<void> startDownload() async {
    final service = FormsStorageService(_api);
    _downloadStatus = DownloadStatus.downloading;
    notifyListeners();
    final file = await service.saveEnvdPdf(_downloadUrl!, _consignmentNo!,
        onReceiveProgress: _onReceiveProgress,);
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

  Future<void> _init() async {
    _service = FormsStorageService(_api);
    _downloadedFile = await _service.checkEnvdInCache(_consignmentNo!);
    if (_downloadedFile != null) {
      _downloadStatus = DownloadStatus.downloaded;
      notifyListeners();
    }
  }
}
