import 'dart:convert';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/forms/models/form_field_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'forms_cubit_state.dart';

class FormsCubit extends ChangeNotifier {
  final Api api;
  // final List<String>? questions;
  // final ValueChanged<Map<String, String>> onSubmit;
  final formKey = GlobalKey<FormState>();
  late FormsState state;
  FormsCubit({required this.api}) : super() {
    state = FormsState(
      pageController: PageController(),
      isLoading: false,
      questions: const [],
      // questions: (questions?.isNotEmpty ?? false) ? _mapFormData(questions!) : [],
      // formData: _mapData(questions ?? [], this),
    );
    // notifyListeners();
    _listenForServiceRoles();
    getUserForms();
    // _mapData(questions ?? [], this);
  }

  static List<QuestionData> _mapFormData(List<String> questions) {
    return questions
        .map(
          (e) => QuestionData(
            question: e,
            // value: e,
          ),
        )
        .toList();
  }

  void _mapData(List<String> questions, FormsCubit cubit) {
    final result = questions
        .map(
          (e) => UserFormData(
            cubit,
            questionData: QuestionData(question: e),
            controller: TextEditingController(),
            name: e,

            // value: e['value'],
          ),
        )
        .toList();
    state = state.copyWith(formData: result);
    notifyListeners();
  }

  void _listenForServiceRoles() {
    // api.getUserRoles();
    api.userRolesStream.listen((event) {
      state = state.copyWith(roles: event);
      notifyListeners();
    });
  }

  List<Forms> forms = [];

  Future<void> getUserForms() async {
    state = state.copyWith(isLoading: true);
    notifyListeners();
    final userData = await api.getUserForms();
    userData.when(
        success: (data) {
          forms = data.data?.forms ?? [];
        },
        failure: (s) {},);
    state = state.copyWith(isLoading: false);
    notifyListeners();
  }

  void onChanged(String value, int index) {
    final map = state.questions.elementAt(index);
    final newMap = map.copyWith(value: value);
    // final newMap = map..questionData.copyWith(value: value);
    final questions = state.questions;
    questions[index] = newMap;
    state.copyWith(questions: [...questions]);
    notifyListeners(); // print(map);
  }

  void onPressed() {
    if (!formKey.currentState!.validate()) return;
    final data = <String, String>{};
    for (final element in state.questions) {
      data[element.question] = element.value.toString();
    }
    // onSubmit.call(data);
    final qrData = jsonEncode(state.questions);
    state = state.copyWith(qrData: qrData);
    notifyListeners();
    // state.pageController.animateToPage(1, duration: kDuration, curve: Curves.easeIn);
  }
}
