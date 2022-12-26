// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/services/notifications/connectivity/connectivity_service.dart';

class SyncService {
  late LocalApi localApi;
  late Api api;
  late MyConnectivity _connectivity = MyConnectivity();
  bool _isSyncing = false;

  // singleton
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  StreamSubscription<List<LogbookEntry>>? _subscription;

  void init(LocalApi localApi, Api api) {
    this.localApi = localApi;
    this.api = api;
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
}
