// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'visitor_check_in_cubit.dart';

class VisitorCheckInState extends Equatable {
  final UserFormsData? formData;
  final bool isLoading;

  const VisitorCheckInState({
    this.formData,
    this.isLoading = false,
  });

  @override
  List<Object> get props => [if (formData != null) formData!, isLoading];

  VisitorCheckInState copyWith({
    UserFormsData? formData,
    bool? isLoading,
  }) {
    return VisitorCheckInState(
      formData: formData ?? this.formData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
