// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/maps/view/widgets/entry_form/cubit/entry_form_cubit.dart';
import 'package:equatable/equatable.dart';

import '../../../../../forms/cubit/forms_cubit_cubit.dart';

class EntryFormState extends Equatable {
  // final List<String> questions;xs
  final bool isLoading;
  // final Map<String, String> questionAnswers;
  // final List<UserFormData> formData;xs
  final List<QuestionData> questions;
  final List<EntryFormData> formData;
  final List<UserRoles>? roles;
  EntryFormState({
    this.questions = const [],
    this.roles,
    this.isLoading = false,
    this.formData = const [],
  });
  @override
  List<Object?> get props => [questions, isLoading, formData, roles];

  EntryFormState copyWith({
    bool? isLoading,
    List<QuestionData>? questions,
    List<EntryFormData>? formData,
    List<UserRoles>? roles,
  }) {
    return EntryFormState(
      isLoading: isLoading ?? this.isLoading,
      questions: questions ?? this.questions,
      formData: formData ?? this.formData,
      roles: roles ?? this.roles,
    );
  }
}
