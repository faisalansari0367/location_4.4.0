// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class OtpState extends Equatable {
  final bool isLoading;
  // final bool isTimeout;
  final bool showCountdown;
  final String? error;

  const OtpState({
    this.isLoading = false,
    this.showCountdown = true,
    this.error,
  });

  OtpState copyWith({
    bool? isLoading,
    bool? showCountdown,
    String? error,
  }) {
    return OtpState(
      isLoading: isLoading ?? this.isLoading,
      showCountdown: showCountdown ?? this.showCountdown,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        showCountdown,
        error,
      ];
}
