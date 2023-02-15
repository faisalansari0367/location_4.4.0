// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';

import 'package:bioplus/constants/index.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/ui/visitor_log_book/cubit/logbook_state.dart';
import 'package:bioplus/ui/visitor_log_book/view/create_pdf.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class LogBookCubit extends BaseModel {
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool isGetting = false;

  LogBookCubit(super.context) {
    // apiService.getLogbookRecords();
    // if (baseState.isConnected) {
    //   sync();
    // }
    apiService.logbookRecordsStream.listen((event) {
      emit(state.copyWith(entries: event));
    });
    // MyConnectivity().connectionStream.listen((isConnected) {

    // });
  }

  // Future<void> sync() async {
  //   if (completer.isCompleted) return;
  //   if (isSynched) return;
  //   final result = await apiService.synchronizeLogRecords();
  //   isSynched = result;
  //   if (completer.isCompleted) return;
  //   completer.complete(result);
  // }

  LogBookState state = const LogBookState();

  void emit(LogBookState state) {
    this.state = state;
    if (!mounted) return;
    notifyListeners();
  }

  final list = [
    if (kDebugMode) 'id',
    'Full Name',
    'entry date',
    'exit date',
    'Zone',
    'PIC/NGR',
    'Post Code',
    'Declaration'
  ];

  // static const headers = ['id', 'Full Name', 'entry date', 'exit date', 'Zone', 'pic', 'Declaration'];

  Future<void> generatePDf() async {
    await Permission.storage.request();
    CreatePDf.createLogbookPDf(list, _generateRows());
  }

  List<List<String>> _generateRows() {
    final rows = state.entries
        .map(
          (item) => [
            if (kDebugMode) item.id.toString(),
            ('${item.user!.firstName!} ${item.user!.lastName}'),
            ('${MyDecoration.formatTime(item.enterDate)}\n${MyDecoration.formatDate(item.enterDate)}'),
            ('${MyDecoration.formatTime(item.exitDate)}\n${MyDecoration.formatDate(item.exitDate)}'),
            (item.geofence?.name ?? ''),
            item.geofence?.pic ?? item.user?.ngr ?? '',
            if (item.user?.postcode == null)
              ''
            else
              (item.user?.postcode).toString(),
            if (item.hasForm)
              'Registered'.toUpperCase()
            else
              'Unregistered'.toUpperCase()
          ],
        )
        .toList();
    return rows;
  }

  String timeAndDate(DateTime? dt) =>
      '${MyDecoration.formatTime(dt)}\n${MyDecoration.formatDate(dt)}';

  Future<void> onRefresh() async {
    final page = state.entries.length / state.limit;
    final currentPage = page.round() + 1;
    emit(state.copyWith(page: currentPage));
    // await refreshIndicatorKey.currentState?.show();
  }

  Future<void> getRecords() async {
    // await completer.future;
    if (isGetting) return;
    isGetting = true;

    final result = await apiService.getLogbookRecords(
      page: state.page,
      limit: state.limit,
    );
    result.when(
      success: (s) async {
        emit(
          state.copyWith(
            entries: s.data,
            hasReachedMax: s.data!.isEmpty && state.page != 1,
          ),
        );
      },
      failure: (failure) => DialogService.failure(error: failure),
    );
    isGetting = false;
  }

  Future<void> generateCsv() async {
    final newHeaders = list.map((e) => e.toUpperCase()).toList();
    final rows = _generateRows();
    rows.insert(0, newHeaders);
    final data = const ListToCsvConverter().convert(rows);
    final String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/csv-${DateTime.now()}.csv";
    final File file = File(path);
    await file.writeAsString(data);

    await Share.shareFiles([(file.path)]);
    // exportCSV.myCSV(newHeaders, rows);
  }
}
