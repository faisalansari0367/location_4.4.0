import 'package:api_repo/api_repo.dart';
import 'package:background_location/helpers/callback_debouncer.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/cubit/logbook_state.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/view/create_pdf.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../constants/index.dart';

class LogBookCubit extends Cubit<LogBookState> {
  final Api api;
  late ScrollController scrollController = ScrollController();
  final CallbackDebouncer _debouncer = CallbackDebouncer(100.milliseconds);

  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  LogBookCubit({required this.api}) : super(const LogBookState()) {
    // getRecords();
    // refreshIndicatorKey.currentState?.show();

    scrollController.addListener(() {
      print(_isScrollingDown);
      if (isAtEnd) {
        if (!_isScrollingDown) return;
        _debouncer.call(() {
          final page = state.entries.length / state.limit;
          final currentPage = page.round() + 1;
          emit(state.copyWith(page: currentPage));
          refreshIndicatorKey.currentState?.show();
        });
      }
    });
  }

  // isAtEnd
  bool get isAtEnd {
    // add delta
    return scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100;
  }

  // bool get _isScrolldingDown {
  //   return scrollController.position.userScrollDirection == ScrollDirection.forward;
  // }

  bool get _isScrollingDown {
    return scrollController.position.userScrollDirection == ScrollDirection.reverse;
  }

  Future<void> generatePDf() async {
    final result = await Permission.storage.request();
    // Permission.manageExternalStorage.request();
    print(result);
    final rows = state.entries
        .map(
          (item) => [
            (item.id.toString()),
            ('${item.user!.firstName!} ${item.user!.lastName}'),
            ('${MyDecoration.formatTime(item.enterDate)}\n${MyDecoration.formatDate(item.enterDate)}'),
            ('${MyDecoration.formatTime(item.exitDate)}\n${MyDecoration.formatDate(item.exitDate)}'),
            (item.geofence?.name ?? ''),
            (item.geofence?.pic ?? ''),
            item.form.isNotEmpty ? 'View'.toUpperCase() : 'Trespasser'.toUpperCase()
          ],
        )
        .toList();
    final headers = ['id', 'Full Name', 'entry date', 'exit date', 'Zone', 'pic', 'Declaration'];
    CreatePDf.createLogbookPDf(headers, rows);
  }

  Future<void> getRecords() async {
    final result = await api.getLogbookRecords(page: state.page, limit: state.limit);
    result.when(
      success: (s) async {
        emit(state.copyWith(entries: s.data));
      },
      failure: (failure) => DialogService.failure(error: failure),
    );
  }
}
