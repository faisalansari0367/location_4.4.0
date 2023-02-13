import 'package:api_repo/api_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'pic_state.dart';

class PicCubit extends Cubit<PicState> {
  final Api api;
  PicCubit({required this.api}) : super(PicInitial()) {
    getPic();

    api.picsStream.listen((event) {
      emit(PicLoaded(pics: event));
    });
  }

  @override
  void emit(PicState state) {
    if (isClosed) {
      return;
    }
    super.emit(state);
  }

  Future<void> getPic() async {
    final result = await api.getPics();
    result.when(
      success: (data) {
        emit(PicLoaded(pics: data));
      },
      failure: (error) {
        final message = NetworkExceptions.getErrorMessage(error);
        emit(PicError(error: message));
      },
    );
  }

  // @override
  // PicState fromJson(Map<String, dynamic> json) {
  //   return PicLoaded.fromJson(json);
  // }

  // @override
  // Map<String, dynamic>? toJson(PicState state) {
  //   // TODO: implement toJson
  //   if (state is PicInitial) return null;
  //   if (state is PicError) return {};
  //   if (state is PicLoaded) {
  //     return state.pics.isEmpty ? {} : state.toMap();
  //   }
  //   return null;
  // }
}
