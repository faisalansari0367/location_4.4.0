import 'dart:convert';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:background_location/ui/maps/view/widgets/entry_form/cubit/entry_from_state.dart';
import 'package:background_location/widgets/dialogs/error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../../widgets/dialogs/dialog_service.dart';

class EntryFormCubit extends Cubit<EntryFormState> {
  final Api api;
  final PolygonModel polygon;
  final MapsRepo mapsApi;

  EntryFormCubit({required this.api, required this.mapsApi, required this.polygon}) : super(EntryFormState()) {
    getFormQuestions();
  }

  Future<void> getFormQuestions() async {
    emit(state.copyWith(isLoading: true));
    final result = await api.getFormQuestions();
    result.when(
      success: (s) {
        // final fieldData = s.map((e) => FieldData(name: e, controller: TextEditingController()));
        emit(state.copyWith(questions: s));
      },
      failure: (e) => DialogService.failure(error: e),
    );
    emit(state.copyWith(isLoading: false));
  }

  // void setAnswer(String q, bool a) {
  //   emit(state.copyWith())
  // }

  void setQuestionValue(String question, bool answer) {
    final map = <String, bool>{}..addAll(state.questionAnswers);
    map[question] = answer;
    print(map);
    // if (map.containsKey(question)) {
    // } else {

    // }
    emit(state.copyWith(questionAnswers: map));
  }

  bool _validate() {
    var result = true;
    for (var element in state.questions) {
      final hasKey = state.questionAnswers.containsKey(element);
      if (!hasKey) {
        result = false;
        break;
      }
    }
    return result;
  }

  void onPressed() async {
    if (!_validate())
      return DialogService.showDialog(
        child: ErrorDialog(
          message: 'Please answer all the questions',
          onTap: Get.back,
          buttonText: 'Try Again',
        ),
      );
    final userData = api.getUserData();
    final result = await mapsApi.logBookEntry(userData!.pic!, jsonEncode(state.questionAnswers), polygon.id!);
    result.when(
      success: (data) {
        DialogService.success('', onCancel: () {
          Get.back();
          Get.back();
        });
        // Get.back();
      },
      failure: (e) => DialogService.failure(error: e),
    );
  }
}
