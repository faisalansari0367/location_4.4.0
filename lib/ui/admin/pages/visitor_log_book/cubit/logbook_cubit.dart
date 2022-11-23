// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/cubit/logbook_state.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/view/create_pdf.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../constants/index.dart';

class LogBookCubit extends Cubit<LogBookState> {
  final Api api;
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  LogBookCubit({required this.api}) : super(const LogBookState());

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
            if (kDebugMode) (item.id.toString()),
            ('${item.user!.firstName!} ${item.user!.lastName}'),
            ('${MyDecoration.formatTime(item.enterDate)}\n${MyDecoration.formatDate(item.enterDate)}'),
            ('${MyDecoration.formatTime(item.exitDate)}\n${MyDecoration.formatDate(item.exitDate)}'),
            (item.geofence?.name ?? ''),
            item.geofence?.pic ?? item.user?.ngr ?? '',
            (item.user?.postcode == null) ? '' : (item.user?.postcode).toString(),
            item.form.isNotEmpty ? 'Registered'.toUpperCase() : 'Unregistered'.toUpperCase()
          ],
        )
        .toList();
    return rows;
  }

  String timeAndDate(DateTime? dt) => '${MyDecoration.formatTime(dt)}\n${MyDecoration.formatDate(dt)}';

  Future<void> onRefresh() async {
    final page = state.entries.length / state.limit;
    final currentPage = page.round() + 1;
    emit(state.copyWith(page: currentPage));
    // await refreshIndicatorKey.currentState?.show();
  }

  Future<void> getRecords() async {
    final result = await api.getLogbookRecords(page: state.page, limit: state.limit);
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
  }

  Future<void> generateCsv() async {
    final newHeaders = list.map((e) => e.toUpperCase()).toList();
    final rows = _generateRows();
    rows.insert(0, newHeaders);
    final data = await ListToCsvConverter().convert(rows);
    final String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/csv-${DateTime.now()}.csv";
    print(path);
    final File file = File(path);
    await file.writeAsString(data);

    await Share.shareFiles([(file.path)]);
    // exportCSV.myCSV(newHeaders, rows);
  }
}

// class TableDataModel {
//   final List<String> headers;
//   TableDataModel({
//     this.headers = const [
//       if (kDebugMode) 'id',
//       'Full Name',
//       'entry date',
//       'exit date',
//       'Zone',
//       'PIC/NGR',
//       'Post Code',
//       'Declaration'
//     ],
//   });
// }

// class TableRowData {
//   final int id;
//   final String fullName;
//   final String entryDate;
//   final String exitDate;
//   final String zone;
//   final String pic;
//   final String ngr;
//   final String postCode;
//   final String declaration;

//   TableRowData({
//     required this.id,
//     required this.fullName,
//     required this.entryDate,
//     required this.exitDate,
//     required this.zone,
//     required this.pic,
//     required this.ngr,
//     required this.postCode,
//     required this.declaration,
//   });
// }
