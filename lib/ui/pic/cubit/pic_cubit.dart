import 'package:api_repo/api_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'pic_state.dart';

class PicCubit extends HydratedCubit<PicState> {
  final Api api;
  PicCubit({required this.api}) : super(PicInitial()) {
    getPic();
  }

  Future<void> getPic() async {
    final result = await api.getPics();
    result.when(
      success: (data) {
        emit(PicLoaded(pics: data));
      },
      failure: (error) {
        emit(PicError(error: NetworkExceptions.getErrorMessage(error)));
      },
    );
  }

  @override
  PicState fromJson(Map<String, dynamic> json) {
    return PicLoaded.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(PicState state) {
    // TODO: implement toJson
    if (state is PicInitial) return null;
    if (state is PicLoaded) {
      return state.toMap();
    }
    return null;
  }
}
