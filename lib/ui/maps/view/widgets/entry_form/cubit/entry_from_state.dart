// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/maps/view/widgets/entry_form/cubit/entry_form_cubit.dart';
import 'package:equatable/equatable.dart';

import '../../../../../forms/cubit/forms_cubit_cubit.dart';

class EntryFormState extends Equatable {
  // final List<String> questions;xs
  final bool isLoading;
  final bool isFirstForm;
  final List<Forms> forms;

  // final Map<String, String> questionAnswers;
  // final List<UserFormData> formData;xs
  final List<QuestionData> questions;
  final List<EntryFormData> formData;
  final List<UserRoles>? roles;
  EntryFormState({
    this.isLoading = false,
    this.isFirstForm = false,
    this.forms = const [],
    this.questions = const [],
    this.formData = const [],
    this.roles,
  });
  @override
  List<Object?> get props => [questions, isLoading, formData, roles, isFirstForm, forms];

  EntryFormState copyWith({
    bool? isLoading,
    bool? isFirstForm,
    List<Forms>? forms,
    List<QuestionData>? questions,
    List<EntryFormData>? formData,
    List<UserRoles>? roles,
  }) {
    return EntryFormState(
      isLoading: isLoading ?? this.isLoading,
      isFirstForm: isFirstForm ?? this.isFirstForm,
      forms: forms ?? this.forms,
      questions: questions ?? this.questions,
      formData: formData ?? this.formData,
      roles: roles ?? this.roles,
    );
  }
}
