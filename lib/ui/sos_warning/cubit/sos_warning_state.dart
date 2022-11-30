part of 'sos_warning_cubit.dart';

/// {@template sos_warning}
/// SosWarningState description
/// {@endtemplate}
class SosWarningState extends Equatable {
  /// {@macro sos_warning}
  const SosWarningState({
    this.customProperty = 'Default Value',
  });

  /// A description for customProperty
  final String customProperty;

  @override
  List<Object> get props => [customProperty];

  /// Creates a copy of the current SosWarningState with property changes
  SosWarningState copyWith({
    String? customProperty,
  }) {
    return SosWarningState(
      customProperty: customProperty ?? this.customProperty,
    );
  }
}
/// {@template sos_warning_initial}
/// The initial state of SosWarningState
/// {@endtemplate}
class SosWarningInitial extends SosWarningState {
  /// {@macro sos_warning_initial}
  const SosWarningInitial() : super();
}
