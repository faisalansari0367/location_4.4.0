import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/forms/cubit/forms_cubit_cubit.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../services/notifications/connectivity/connectivity_service.dart';
import '../../../../../../widgets/dialogs/dialog_service.dart';
import 'entry_from_state.dart';

class EntryFormCubit extends ChangeNotifier {
  final Api api;
  final LocalApi localApi;
  final PolygonModel polygon;
  final MapsRepo mapsApi;
  late EntryFormState state;

  late Api _apiService = api;

  EntryFormCubit({
    required this.localApi,
    required this.api,
    required this.mapsApi,
    required this.polygon,
  }) : state = const EntryFormState() {
    getFormQuestions();
    _listenForServiceRoles();

    final connectivity = MyConnectivity();
    _apiService = api;
    connectivity.connectionStream.listen((event) {
      _apiService = event ? api : localApi;
      emit(state.copyWith(isConnected: event));
    });
  }

  void emit(EntryFormState state) {
    this.state = state;
    notifyListeners();
  }

  Future<void> getFormQuestions() async {
    emit(state.copyWith(isLoading: true));
    await 200.milliseconds.delay();
    final result = await _apiService.getUserForms();
    result.when(
      success: (s) {
        final userData = api.getUserData();
        final role = userData!.role!.getRole;

        if (polygon.name == 'Gavin') {
          emit(
            state.copyWith(
              forms: s.data?.forms,
              questions: _mapQuestions(s.data?.forms?.first.questions),
              isFirstForm: true,
            ),
          );
          return;
        }

        // if (userData.company != null) {
        //   if (userData.company!.contains('aurora')) {

        //   }
        // emit(
        //   state.copyWith(
        //     forms: s.data?.forms,
        //     questions: _mapQuestions(s.data?.forms?[1].questions),
        //     isFirstForm: false,
        //   ),
        // );
        // return;

        if (role.isInternationalTraveller || role.isVisitor || role.isAdmin) {
          emit(
            state.copyWith(
              forms: s.data?.forms,
              questions: _mapQuestions(s.data?.forms?.first.questions),
              isFirstForm: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              forms: s.data?.forms,
              questions: _mapQuestions(s.data?.forms?[1].questions),
              isFirstForm: false,
            ),
          );
        }
      },
      failure: (e) => DialogService.failure(error: e),
    );
    emit(state.copyWith(isLoading: false));
  }

  List<QuestionData> _mapQuestions(List<String>? questions) {
    return (questions ?? []).map((e) => QuestionData(question: e)).toList();
  }

  Future<void> submitFormData(String json) async {
    final result = await api.udpateForm(polygon.id!, json);
    result.when(
      success: (data) {
        DialogService.success(
          'Form Submitted',
          onCancel: () {
            Get.back();
            Get.back();
          },
        );
      },
      failure: (e) => DialogService.failure(error: e),
    );
  }

  void _listenForServiceRoles() {
    api.userRolesStream.listen((event) {
      state = state.copyWith(roles: event);
      notifyListeners();
    });
  }
}
