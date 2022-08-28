import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/cubit/logbook_state.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogBookCubit extends Cubit<LogBookState> {
  final Api api;
  LogBookCubit({required this.api}) : super(LogBookState()) {
    getRecords();
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
