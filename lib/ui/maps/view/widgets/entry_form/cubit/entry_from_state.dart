// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class EntryFormState extends Equatable {
  final List<String> questions;
  final bool isLoading;
  final Map<String, String> questionAnswers;
  EntryFormState({
    this.questionAnswers = const {},
    this.isLoading = false,
    this.questions = const [],
  });
  @override
  List<Object?> get props => [questions, isLoading, questionAnswers];

  EntryFormState copyWith({
    List<String>? questions,
    bool? isLoading,
    Map<String, String>? questionAnswers,
  }) {
    return EntryFormState(
      questions: questions ?? this.questions,
      isLoading: isLoading ?? this.isLoading,
      questionAnswers: questionAnswers ?? this.questionAnswers,
    );
  }
}
