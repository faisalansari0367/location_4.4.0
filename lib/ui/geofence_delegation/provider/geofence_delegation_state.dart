// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class GeofenceDelegationState extends Equatable {
  final String email;
  final DateTime startDate;
  final DateTime? endDate;

  GeofenceDelegationState({
    this.email = '',
    required this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [email, startDate, endDate];

  GeofenceDelegationState copyWith({
    String? email,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return GeofenceDelegationState(
      email: email ?? this.email,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'delegationStartDate': startDate.toIso8601String(),
      'delegationEndDate': endDate?.toIso8601String(),
    };
  }
}
