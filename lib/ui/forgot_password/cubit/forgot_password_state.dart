// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ForgotPasswordState extends Equatable {
  final bool isLoading;
  // final bool isTimeout;
  final bool showCountdown;
  final String? error;
  final String email;
  final String? otp;

  const ForgotPasswordState({
    required this.email,
    this.otp,
    this.isLoading = false,
    this.showCountdown = true,
    this.error,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    bool? showCountdown,
    String? error,
    String? email,
    String? otp,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      showCountdown: showCountdown ?? this.showCountdown,
      error: error ?? this.error,
      email: email ?? this.email,
      otp: otp ?? this.otp,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        showCountdown,
        error,
        email,
        otp,
      ];
}
