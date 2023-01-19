// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'work_safety_cubit.dart';

/// {@template work_safety}
/// WorkSafetyState description
/// {@endtemplate}
class WorkSafetyState extends Equatable {
  /// {@macro work_safety}
  final UserData userData;
  const WorkSafetyState({
    required this.userData,
  });

  @override
  List<Object> get props => [userData];

  /// Creates a copy of the current WorkSafetyState with property changes
  WorkSafetyState copyWith({
    UserData? userData,
  }) {
    return WorkSafetyState(
      userData: userData ?? this.userData,
    );
  }
}

/// {@template work_safety_initial}
/// The initial state of WorkSafetyState
/// {@endtemplate}
class WorkSafetyInitial extends WorkSafetyState {
  /// {@macro work_safety_initial}
  const WorkSafetyInitial({required super.userData});
}
