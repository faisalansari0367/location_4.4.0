import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/cubit/logbook_state.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/view/create_pdf.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../constants/index.dart';

class LogBookCubit extends Cubit<LogBookState> {
  final Api api;
  LogBookCubit({required this.api}) : super(LogBookState()) {
    getRecords();
  }

  Future<void> generatePDf() async {
    final result = await Permission.storage.request();
    // Permission.manageExternalStorage.request();
    print(result);
    final rows = state.entries
        .map((item) => [
              (item.id.toString()),
              ('${item.user!.firstName!} ${item.user!.lastName}'),
              (MyDecoration.formatTime(item.enterDate) + '\n' + MyDecoration.formatDate(item.enterDate)),
              (MyDecoration.formatTime(item.exitDate) + '\n' + MyDecoration.formatDate(item.exitDate)),
              (item.geofence?.name ?? ''),
              (item.geofence?.pic ?? ''),
            ])
        .toList();
    final headers = ['id', 'Full Name', 'entry date', 'exit date', 'Zone', 'pic'];
    CreatePDf.createLogbookPDf(headers, rows);
  }

  Future<void> getRecords() async {
    emit(state.copyWith(isLoading: true));
    final result = await api.getLogbookRecords();
    result.when(
      success: (s) => {emit(state.copyWith(entries: s.data))},
      failure: (failure) => DialogService.failure(error: failure),
    );
    emit(state.copyWith(isLoading: false));
  }
}
