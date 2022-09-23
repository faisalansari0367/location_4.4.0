// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'visitor_check_in_cubit.dart';

class VisitorCheckInState extends Equatable {
  final UserFormsData? formData;
  final String? qrCode;
  final bool isLoading;

  const VisitorCheckInState({
    this.qrCode,
    this.formData,
    this.isLoading = false,
  });

  @override
  List<Object> get props => [
        if (formData != null) formData!,
        isLoading,
        if (qrCode != null) qrCode!,
      ];

  VisitorCheckInState copyWith({
    UserFormsData? formData,
    String? qrCode,
    bool? isLoading,
  }) {
    return VisitorCheckInState(
      formData: formData ?? this.formData,
      qrCode: qrCode ?? this.qrCode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
