import 'package:api_repo/api_repo.dart';
import 'package:background_location/helpers/callback_debouncer.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/cubit/logbook_state.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/view/create_pdf.dart';
import 'package:background_location/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../constants/index.dart';

class LogBookCubit extends Cubit<LogBookState> {
  final Api api;
  late ScrollController scrollController = ScrollController();
  final CallbackDebouncer _debouncer = CallbackDebouncer(100.milliseconds);
  LogBookCubit({required this.api}) : super(const LogBookState()) {
    getRecords();

    scrollController.addListener(() {
      if (isAtEnd) {
        _debouncer.call(() {
          // emit(state.copyWith(page: state.page + 1));
          // getRecords();
        });
      }
    });
  }

  // isAtEnd
  bool get isAtEnd {
    // add delta
    return scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100;
  }

  Future<void> generatePDf() async {
    final result = await Permission.storage.request();
    // Permission.manageExternalStorage.request();
    print(result);
    final rows = state.entries
        .map((item) => [
              (item.id.toString()),
              ('${item.user!.firstName!} ${item.user!.lastName}'),
              ('${MyDecoration.formatTime(item.enterDate)}\n${MyDecoration.formatDate(item.enterDate)}'),
              ('${MyDecoration.formatTime(item.exitDate)}\n${MyDecoration.formatDate(item.exitDate)}'),
              (item.geofence?.name ?? ''),
              (item.geofence?.pic ?? ''),
              item.form.isNotEmpty ? 'View'.toUpperCase() : 'Trespasser'.toUpperCase()
            ])
        .toList();
    final headers = ['id', 'Full Name', 'entry date', 'exit date', 'Zone', 'pic', 'Declaration'];
    CreatePDf.createLogbookPDf(headers, rows);
  }

  Future<void> getRecords() async {
    await 100.milliseconds.delay();
    BottomSheetService.showSheet(
      child: Row(
        children: [
          SizedBox.square(
            child: const CircularProgressIndicator(),
            dimension: 25,
          ),
          const SizedBox(width: 10),
          const Text('Logbook updating'),
        ],
      ),
    );
    final result = await api.getLogbookRecords(page: state.page);

    result.when(
      success: (s) async {
        if (Get.isBottomSheetOpen ?? false) Get.back();
        emit(state.copyWith(entries: [...state.entries, ...(s.data ?? [])]));
      },
      failure: (failure) => DialogService.failure(error: failure),
    );
    // emit(state.copyWith(isLoading: false));
  }
}
