import 'dart:async';

import 'package:api_repo/api_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'work_safety_state.dart';

class WorkSafetyCubit extends Cubit<WorkSafetyState> {
  final Api api;

  WorkSafetyCubit({required this.api}) : super(WorkSafetyInitial(userData: api.getUserData()!));

  FutureOr<void> yourCustomFunction() {
    // TODO: Add Logic
  }
}
