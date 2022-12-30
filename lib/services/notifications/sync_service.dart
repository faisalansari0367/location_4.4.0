// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/services/notifications/connectivity/connectivity_service.dart';
import 'package:cvd_forms/models/src/cvd_form.dart';
import 'package:flutter/foundation.dart';

import 'forms_storage_service.dart';

class SyncService {
  late LocalApi localApi;
  late Api api;
  late FormsStorageService formsStorageService;
  late MyConnectivity _connectivity = MyConnectivity();
  bool _isSyncing = false;
  bool _isCvdSyncing = false;

  // singleton
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  StreamSubscription<List<LogbookEntry>>? _subscription;

  void init(LocalApi localApi, Api api) {
    this.localApi = localApi;
    this.api = api;
    formsStorageService = FormsStorageService(api);
    _connectivity.connectionStream.listen(_listener);
  }

  void _listener(bool event) {
    if (event) {
      _subscription?.cancel();
      _subscription = localApi.offlineRecordsToSync.listen(_recordsSyncher);
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
      print('synching failed $e');
      _isSyncing = false;
    }
  }

  Future<void> syncCvds() async {
    try {
      log('synching data');
      log('connection available: ${MyConnectivity.isConnected}');
      if (_isCvdSyncing) return;
      _isCvdSyncing = true;
      final forms = await api.getCvdForms();
      forms.when(success: (data) async {
        if (!MyConnectivity.isConnected) return;
        await _createCvdPdf(data);
        final pdfs = await formsStorageService.getCvdForms();
        if (pdfs.isNotEmpty) {
          final base64s = await pdfsToBase64(pdfs);
          await api.updateCvdForms(base64pdfs: base64s);
        }
      }, failure: (s) {
        print('failed to get forms');
        _isSyncing = false;
      });
    } on Exception catch (e) {
      print('synching failed $e');
      _isSyncing = false;
    }
    _isSyncing = false;
  }

  Future<void> _createCvdPdf(List<CvdForm> data) async {
    for (final cvdForm in data) {
      final file = await api.submitForm(cvdForm);
      file.when(
        success: (Uint8List bytes) async {
          await formsStorageService.saveCvdForm(bytes, cvdForm.buyerDetailsModel?.name?.value ?? '');
          // removeCvds.add(cvdForm);
          api.deleteForm(cvdForm);
        },
        failure: (s) {
          print('failed to submit forms');
        },
      );
    }
  }

  Future<List<String>> pdfsToBase64(List<FileSystemEntity> pdfs) async {
    final List<String> base64s = [];
    for (var fileEntity in pdfs) {
      if (fileEntity is File) {
        final bytes = await fileEntity.readAsBytes();
        final base64 = jsonEncode(bytes);
        base64s.add(base64);
      }
    }
    return base64s;
  }
}
