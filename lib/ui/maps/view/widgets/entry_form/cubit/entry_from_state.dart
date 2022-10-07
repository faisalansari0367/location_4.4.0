// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_repo.dart';
import 'package:equatable/equatable.dart';

import '../../../../../forms/cubit/forms_cubit_cubit.dart';

class EntryFormState extends Equatable {
  // final List<String> questions;xs
  final bool isLoading;
  final bool isFirstForm;
  final bool isConnected;

  final List<Forms> forms;

  // final Map<String, String> questionAnswers;
  // final List<UserFormData> formData;xs
  final List<QuestionData> questions;
  // final List<EntryFormData> formData;
  final List<UserRoles>? roles;
  const EntryFormState({
    this.isConnected = false,
    this.isLoading = false,
    this.isFirstForm = false,
    this.forms = const [],
    this.questions = const [],
    // this.formData = const [],
    this.roles,
  });
  @override
  List<Object?> get props => [questions, isLoading,  roles, isFirstForm, forms, isConnected];

  EntryFormState copyWith({
    bool? isLoading,
    bool? isFirstForm,
    bool? isConnected,
    List<Forms>? forms,
    List<QuestionData>? questions,
    List<UserRoles>? roles,
  }) {
    return EntryFormState(
      isLoading: isLoading ?? this.isLoading,
      isFirstForm: isFirstForm ?? this.isFirstForm,
      isConnected: isConnected ?? this.isConnected,
      forms: forms ?? this.forms,
      questions: questions ?? this.questions,
      roles: roles ?? this.roles,
    );
  }
}
