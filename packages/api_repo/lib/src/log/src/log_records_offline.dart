import 'package:hive_flutter/adapters.dart';
import 'package:rxdart/rxdart.dart';

import '../../../api_repo.dart';

abstract class OfflineLogRecords {
  Future<void> addOfflineRecord(LogbookEntry entry);
  List<LogbookEntry> getOfflineLogRecords();
  Future<LogbookEntry> update(LogbookEntry entry);
  Future<void> clearOfflineRecords();
  Future<void> remove(LogbookEntry entry);
}

class OfflineLogRecordsImpl implements OfflineLogRecords {
  OfflineLogRecordsImpl({
    required this.box,
  }) {
    init();
  }
  final Box box;
  static const String offlineLogRecords = 'offlineLogRecords';
  final _controller = BehaviorSubject<List<LogbookEntry>>.seeded([]);

  void init() {
    getOfflineLogRecords();
    box.watch(key: offlineLogRecords).listen((event) {
      if (event.value == null) return;
      // log('offline entries: ${jsonEncode(event.value)}');
      final entries = event.value.map((e) => LogbookEntry.fromJson(_parseData(e)!)).toList();
      _controller.add(List<LogbookEntry>.from(entries));
    });
  }

  @override
  Future<void> addOfflineRecord(LogbookEntry entry) async {
    // final List<LogbookEntry> _logRecords = getOfflineLogRecords();
    // print('adding entry in offline records before${logRecords.length}');
    logRecords.add(entry);
    // print('adding entry in offline records after${logRecords.length}');

    await _saveOfflineRecords(logRecords);
  }

  Future<void> _saveOfflineRecords(List<LogbookEntry> entries) async {
    try {
      await box.put(offlineLogRecords, entries.map((e) => e.toJson()).toList());
      // _controller.add(entries);
    } catch (e) {
      rethrow;
    }
  }

  @override
  List<LogbookEntry> getOfflineLogRecords() {
    final List result = box.get(offlineLogRecords, defaultValue: []);
    final entries = result.map((e) => LogbookEntry.fromJson(_parseData(e)!)).toList();
    // _controller.add(List<LogbookEntry>.from(entries));
    return entries;
  }

  @override
  Future<LogbookEntry> update(LogbookEntry entry) async {
    // problem is in updating the offline records
    // when the log record is on the server
    // one additional entry is added to the offline records
    // need to find a way to update the offline records
    // without creating the duplicate entry

    final index = logRecords.indexWhere(
      (element) =>
          element.id == entry.id ||
          element.enterDate == entry.enterDate &&
              element.geofence?.id == entry.geofence?.id &&
              element.user?.id == entry.user?.id,
    );
    if (index == -1) {
      logRecords.insert(0, entry);
    } else {
      logRecords[index] = entry;
    }

    await _saveOfflineRecords(logRecords);
    return entry;
  }

  // void _listen() {
  //   box.watch(key: offlineLogRecords).listen((event) {
  //     final entries = event.value.map((e) => LogbookEntry.fromJson(_parseData(e)!)).toList();
  //     _controller.add(List<LogbookEntry>.from(entries));
  //   });
  // }

  @override
  Future<void> remove(LogbookEntry entry) async {
    final index = logRecords.indexWhere((element) => element.id == entry.id);
    if (index == -1) {
      return;
    } else {
      logRecords.removeAt(index);
    }

    await _saveOfflineRecords(logRecords);
  }

  @override
  Future<void> clearOfflineRecords() async {
    try {
      await box.put(offlineLogRecords, []);
      // _controller.add([]);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic>? _parseData(data) {
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  List<LogbookEntry> get logRecords => _controller.value;
  Stream<List<LogbookEntry>> get logbookRecordsStream => _controller.stream;
}
