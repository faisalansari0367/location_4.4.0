import 'dart:async';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/widgets/dialogs/dialogs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:provider/provider.dart';

part 'declarations_forms_state.dart';

class DeclarationsFormsCubit extends HydratedCubit<DeclarationsFormsState> {
  late Api api;
  final LogbookFormModel form;

  DeclarationsFormsCubit(BuildContext context, {required this.form})
      : super(const DeclarationsFormsState()) {
    final Api api = context.read<Api>();
    this.api = api;
    getForms();
  }

  UserData? get user => api.getUserData();

  Future<void> getForms() async {
    final result = await api.getDeclarationForms();
    result.when(
      success: success,
      failure: failure,
    );
  }

  @override
  DeclarationsFormsState? fromJson(Map<String, dynamic> json) {
    return DeclarationsFormsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(DeclarationsFormsState state) {
    return state.toJson();
  }

  void success(List<DeclarationForms> data) {
    emit(state.copyWith(forms: data));
  }

  void failure(NetworkExceptions error) {
    DialogService.failure(error: error);
  }

  DeclarationForms? getFormByType() {
    if(state.forms.isEmpty) return null;
    return state.forms.firstWhere((element) => element.type == form.type);
  }
}
