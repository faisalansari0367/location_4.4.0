// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'declarations_forms_cubit.dart';

/// {@template declarations_forms}
/// DeclarationsFormsState description
/// {@endtemplate}
class DeclarationsFormsState extends Equatable {
  /// {@macro declarations_forms}
  const DeclarationsFormsState({
    this.forms = const [],
  });

  /// A description for customProperty
  final List<DeclarationForms> forms;

  @override
  List<Object> get props => [forms];

  DeclarationsFormsState copyWith({
    List<DeclarationForms>? forms,
  }) {
    return DeclarationsFormsState(
      forms: forms ?? this.forms,
    );
  }
}
