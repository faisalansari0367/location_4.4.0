import 'dart:async';

import 'package:bioplus/ui/forms/global_form/cubit/cubit.dart';
import 'package:equatable/equatable.dart';

part 'global_form_state.dart';

class GlobalFormCubit extends Cubit<GlobalFormState> {
  GlobalFormCubit() : super(const GlobalFormInitial());

  /// A description for yourCustomFunction
  FutureOr<void> yourCustomFunction() {
    // TODO: Add Logic
  }
}
