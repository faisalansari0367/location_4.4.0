part of 'global_form_cubit.dart';

/// {@template global_form}
/// GlobalFormState description
/// {@endtemplate}
class GlobalFormState extends Equatable {
  /// {@macro global_form}
  /// 
  const GlobalFormState({
    this.customProperty = 'Default Value',
  });

  /// A description for customProperty
  final String customProperty;

  @override
  List<Object> get props => [customProperty];

  /// Creates a copy of the current GlobalFormState with property changes
  GlobalFormState copyWith({
    String? customProperty,
  }) {
    return GlobalFormState(
      customProperty: customProperty ?? this.customProperty,
    );
  }
}
/// {@template global_form_initial}
/// The initial state of GlobalFormState
/// {@endtemplate}
class GlobalFormInitial extends GlobalFormState {
  /// {@macro global_form_initial}
  const GlobalFormInitial() : super();
}
