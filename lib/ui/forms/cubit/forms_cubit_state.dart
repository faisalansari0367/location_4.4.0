// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'forms_cubit_cubit.dart';

class QuestionData extends Equatable {
  final String question;
  final dynamic value;

  QuestionData({required this.question, this.value});
  @override
  List<Object?> get props => [question, value];

  QuestionData copyWith({
    String? question,
    dynamic value,
  }) {
    return QuestionData(
      question: question ?? this.question,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'question': question,
      'value': value,
    };
  }

  factory QuestionData.fromJson(Map<String, dynamic> map) {
    return QuestionData(
      question: map['question'] as String,
      value: map['value'] as dynamic,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory QuestionData.fromJson(String source) => QuestionData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class FormsState extends Equatable {
  final List<QuestionData> questions;
  final List<UserFormData> formData;
  final List<String> roles;

  final PageController pageController;
  final String? qrData;
  final bool isLoading;
  const FormsState({
    this.roles = const [], 
    required this.questions,
    this.formData = const [],
    required this.pageController,
    this.qrData,
    required this.isLoading,
  });

  @override
  List<Object> get props => [questions, isLoading, pageController, formData, roles];

  FormsState copyWith({
    List<QuestionData>? questions,
    List<UserFormData>? formData,
    List<String>? roles,
    PageController? pageController,
    String? qrData,
    bool? isLoading,
  }) {
    return FormsState(
      questions: questions ?? this.questions,
      formData: formData ?? this.formData,
      roles: roles ?? this.roles,
      pageController: pageController ?? this.pageController,
      qrData: qrData ?? this.qrData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
