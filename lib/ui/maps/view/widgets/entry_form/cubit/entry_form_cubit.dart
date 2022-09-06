import 'dart:convert';

import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/forms/cubit/forms_cubit_cubit.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:background_location/ui/role_details/models/field_data.dart';
import 'package:background_location/widgets/dialogs/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../widgets/dialogs/dialog_service.dart';
import '../../../../../../widgets/text_fields/text_fields.dart';
import '../../../../../forms/widget/form_card.dart';
import 'entry_from_state.dart';

class EntryFormData extends FieldData {
  final QuestionData questionData;
  final EntryFormCubit cubit;
  EntryFormData({
    required this.cubit,
    required this.questionData,
    required String name,
    required TextEditingController controller,
  }) : super(name: name, controller: controller);

  @override
  Widget get fieldWidget {
    switch (name.toCamelCase) {
      case 'serviceRole':
        return MyDropdownField(
          options: cubit.state.roles,
          onChanged: (s) => controller.text = s!,
          hintText: 'Select Role',
          value: controller.text,
        );
      case 'reasonForVisit':
        return MyTextField(
          hintText: 'Reason For Visit',
          controller: controller,
          maxLines: 1,
        );
      case 'riskRating':
        return Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: MyDropdownField(
            options: ['Low', 'Medium', 'High'],
            onChanged: (s) => controller.text = s!,
            hintText: 'Risk rating',
            value: controller.text,
          ),
        );
      case 'expectedDepartureTime':
      case 'day/date/time':
        return MyDateField(
          label: name,
          onChanged: (s) => controller.text = s,
          date: controller.text,
        );
      case 'fullName':
      case 'nameOfWarakirriFarmVisiting':
      case 'rego':
        return MyTextField(
          hintText: name,
          onChanged: (s) => controller.text = s,
          // date: controller.text,
        );
      case 'company':
      case 'mobile':
      case 'signature':
        return super.fieldWidget;
      default:
        return QuestionCard(
          question: questionData.question,
          selectedValue: questionData.value,
          onChanged: (s) {
            cubit.onChanged(s, cubit.state.formData.indexOf(this));
          },
        );
    }
  }
}

class EntryFormCubit extends ChangeNotifier {
  final Api api;
  final PolygonModel polygon;
  final MapsRepo mapsApi;
  late EntryFormState state;

  EntryFormCubit({required this.api, required this.mapsApi, required this.polygon})
      : state = EntryFormState(formData: []) {
    getFormQuestions();
    _listenForServiceRoles();
  }

  void emit(EntryFormState state) {
    this.state = state;
    notifyListeners();
  }

  Future<void> getFormQuestions() async {
    emit(state.copyWith(isLoading: true));
    final result = await api.getUserForms();
    result.when(
      success: (s) {
        final userData = api.getUserData();
        final role = userData!.role!.getRole;
        // if (role.isInternationalTraveller || role.isVisitor) {
        if (role.isInternationalTraveller || role.isVisitor) {
          emit(
            state.copyWith(
              questions: _mapQuestions(s.data?.forms?.first.questions),
              formData: _getFormData(s.data?.forms?.first.questions),
            ),
          );
        } else {
          emit(
            state.copyWith(
              questions: _mapQuestions(s.data?.forms?[1].questions),
              formData: _getFormData(s.data?.forms?[1].questions),
            ),
          );
        }
      },
      failure: (e) => DialogService.failure(error: e),
    );
    emit(state.copyWith(isLoading: false));
  }

  List<EntryFormData> _getFormData(List<String>? questions) {
    return (questions ?? [])
        .map(
          (e) => EntryFormData(
            cubit: this,
            questionData: QuestionData(question: e),
            controller: TextEditingController(),
            name: e.replaceAll(':', ''),
          ),
        )
        .toList();
  }

  List<QuestionData> _mapQuestions(List<String>? questions) {
    return (questions ?? []).map((e) => QuestionData(question: e)).toList();
  }

  void generateFormData(List<String> questions) {
    // return questions.map((e) => UserFormData(

    // )).toList();
  }

  // void setAnswer(String q, bool a) {
  //   emit(state.copyWith())
  // }

  void setQuestionValue(String question, String answer) {
    // final map = <String, String>{}..addAll(state.questionAnswers);
    // map[question] = answer;
    // print(map);
    // if (map.containsKey(question)) {
    // } else {

    // }
    // emit(state.copyWith(questionAnswers: map));
  }

  bool _validate() {
    // getFormData(data);
    final jsonData = getJsonData();
    bool result = true;
    for (var item in jsonData) {
      if (item.containsValue(null) || item.containsValue('')) {
        result = false;
        break;
      }
    }
    return result;
  }

  // void getFormData(Map<String, String> data) {
  //   // emit(state.copyWith(questionAnswers: data));
  // }

  List<Map<String, dynamic>> getJsonData() {
    final map = <Map<String, dynamic>>[];
    state.formData.forEach((element) {
      if (element.fieldWidget is QuestionCard) {
        map.add(element.questionData.toJson());
      } else {
        map.add(QuestionData(question: element.name, value: element.controller.text).toJson());
      }
    });
    return map;
  }

  Future<void> onPressed() async {
    if (!_validate())
      return DialogService.showDialog(
        child: ErrorDialog(
          message: 'All fields are required',
          onTap: Get.back,
          buttonText: 'Try Again',
        ),
      );
    final userData = api.getUserData();
    // getJsonData();
    final result = await mapsApi.logBookEntry(userData!.pic!, jsonEncode(getJsonData()), polygon.id!);
    result.when(
      success: (data) {
        DialogService.success('Form Submitted', onCancel: () {
          Get.back();
          Get.back();
        });
        // Get.back();
      },
      failure: (e) => DialogService.failure(error: e),
    );
  }

  void _listenForServiceRoles() {
    // api.getUserRoles();

    api.userRolesStream.listen((event) {
      state = state.copyWith(roles: event);
      notifyListeners();
    });
  }

  void onChanged(String value, int index) {
    final data = state.formData[index];
    final questionData = data.questionData.copyWith(value: value);
    final newFormData = EntryFormData(
      cubit: this,
      questionData: questionData,
      name: data.name,
      controller: data.controller,
    );
    state.formData[index] = newFormData;

    emit(state.copyWith(formData: state.formData));
    // notifyListeners(); // print(map);
  }
}
