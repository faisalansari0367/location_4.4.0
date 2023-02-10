// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import '../log_records.dart';

class LogRecordsHelper {
  final int? userId;
  final LogRecordsLocalStorage storage;
  LogRecordsHelper({
    required this.userId,
    required this.storage,
  });

  Iterable<LogbookEntry> _getLogRecordsByGeofenceId(String id) =>
      storage.logRecords
          .where((element) => element.geofence?.id == int.parse(id));

  bool isCreatedByUser(LogbookEntry element) => element.user?.id == userId;
  bool isLoggedInZone(LogbookEntry element) => element.exitDate == null;

  bool isCreatedIn15Minutes(LogbookEntry element) {
    final difference = DateTime.now().difference(element.enterDate!);
    if (!element.hasForm) {
      return difference.inHours <= 24;
    }
    if (element.exitDate == null) {
      return true;
    }
    return difference.inMinutes <= 30;
  }

  Future<LogbookEntry?> getLogRecord({required String geofenceId}) async {
    /// records of this geofence
    final geofenceRecords = _getLogRecordsByGeofenceId(geofenceId);

    if (kDebugMode) {
      print('geofence $geofenceId records: ${geofenceRecords.length}');
    }

    // records created by the current user for this geofence
    final recordsByUser = geofenceRecords.where(isCreatedByUser);
    if (kDebugMode) {
      print('recordsByUser length: ${recordsByUser.length}');
    }

    // records created by the current user for this geofence in the last 15 minutes
    final recordsPast15Minutes = recordsByUser.where(isCreatedIn15Minutes);

    if (kDebugMode) {
      print('records in last 15 minutes: ${recordsPast15Minutes.length}');
    }

    // get the latest record
    if (recordsPast15Minutes.isNotEmpty) {
      return recordsPast15Minutes.first;
    } else {
      return null;
    }
  }
}
