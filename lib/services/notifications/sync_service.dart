// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/services/notifications/connectivity/connectivity_service.dart';
import 'package:bioplus/services/notifications/forms_storage_service.dart';
import 'package:bioplus/widgets/upload/upload_controller.dart';
import 'package:cvd_forms/models/models.dart';
import 'package:flutter/material.dart';

class SyncService {
  late LocalApi localApi;
  late Api api;
  late FormsStorageService formsStorageService;
  late final MyConnectivity _connectivity = MyConnectivity();
  bool _isSyncing = false;
  bool _isCvdSyncing = false;
  late SyncCvdController syncCvdController;

  // singleton
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  StreamSubscription<List<LogbookEntry>>? _subscription;
  StreamSubscription<List<CvdForm>>? _cvdSubscription;

  void init(LocalApi localApi, Api api) {
    this.localApi = localApi;
    this.api = api;
    formsStorageService = FormsStorageService(api);
    syncCvdController = SyncCvdController(
      cvdFormsRepo: api,
      
    );
    _connectivity.connectionStream.listen(_listener);
  }

  static bool? _isConnected;
  void _listener(bool event) {
    if (_isConnected == event) return;

    _isConnected = event;

    if (event) {
      _subscription?.cancel();
      _subscription = localApi.offlineRecordsToSync.listen(_recordsSyncher);
      // _cvdSubscription = api.cvdFormsStream.listen((event) {
      syncCvds();
      // });
    }
  }

  Future<void> _recordsSyncher(records) async {
    try {
      if (records.isEmpty) return;
      if (_isSyncing) return;
      _isSyncing = true;
      log('synching data');
      log('connection available: ${MyConnectivity.isConnected}');
      if (MyConnectivity.isConnected) await api.synchronizeLogRecords();
      _isSyncing = false;
    } on Exception catch (e) {
      debugPrint('synching failed $e');
      _isSyncing = false;
    }
  }

  Future<void> syncCvds() async {
    try {
      final isUploading =
          syncCvdController.uploadStatus == UploadStatus.uploading;
      if (isUploading) return;
      log('synching data');
      log('connection available: ${MyConnectivity.isConnected}');
      // if (_isCvdSyncing) return;
      // _isCvdSyncing = true;
      // await syncCvdController.startUpload();
      // _isCvdSyncing = false;
    } on Exception catch (e) {
      debugPrint('synching failed $e');
      // _isSyncing = false;
    }
    // _isSyncing = false;
  }
}
