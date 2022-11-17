import 'dart:io';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/cubit/logbook_state.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/view/create_pdf.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:csv/csv.dart';
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

  static const headers = ['id', 'Full Name', 'entry date', 'exit date', 'Zone', 'pic', 'Declaration'];

  Future<void> generatePDf() async {
    await Permission.storage.request();
    final headers = ['id', 'Full Name', 'entry date', 'exit date', 'Zone', 'pic', 'Declaration'];
    final rows = state.entries
        .map(
          (item) => [
            (item.id.toString()),
            ('${item.user!.firstName!} ${item.user!.lastName}'),
            ('${MyDecoration.formatTime(item.enterDate)}\n${MyDecoration.formatDate(item.enterDate)}'),
            ('${MyDecoration.formatTime(item.exitDate)}\n${MyDecoration.formatDate(item.exitDate)}'),
            (item.geofence?.name ?? ''),
            (item.geofence?.pic ?? ''),
            item.form.isNotEmpty ? 'Registered'.toUpperCase() : 'Unregistered'.toUpperCase()
          ],
        )
        .toList();
    CreatePDf.createLogbookPDf(headers, rows);
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
    final headers = ['id', 'Full Name', 'entry date', 'exit date', 'Zone', 'pic', 'Declaration'];
    final newHeaders = headers.map((e) => e.toUpperCase()).toList();
    final rows = state.entries
        .map(
          (item) => [
            (item.id.toString()),
            ('${item.user!.firstName!} ${item.user!.lastName}'),
            ('${MyDecoration.formatTime(item.enterDate)}\n${MyDecoration.formatDate(item.enterDate)}'),
            ('${MyDecoration.formatTime(item.exitDate)}\n${MyDecoration.formatDate(item.exitDate)}'),
            (item.geofence?.name ?? ''),
            (item.geofence?.pic ?? ''),
            item.form.isNotEmpty ? 'Registered'.toUpperCase() : 'Unregistered'.toUpperCase()
          ],
        )
        .toList();
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
