// ignore_for_file: public_member_api_docs, sort_constructors_first
class TemporaryOwnerParams {
  final String? email;
  final DateTime? delegationStartDate;
  final DateTime? delegationEndDate;
  TemporaryOwnerParams({
    required this.email,
    required this.delegationStartDate,
    required this.delegationEndDate,
  });

  TemporaryOwnerParams copyWith({
    String? email,
    DateTime? startDelegationDate,
    DateTime? endDelegationDate,
  }) {
    return TemporaryOwnerParams(
      email: email ?? this.email,
      delegationStartDate: startDelegationDate ?? delegationStartDate,
      delegationEndDate: endDelegationDate ?? delegationEndDate,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'delegationStartDate': delegationStartDate?.toIso8601String(),
      'delegationEndDate': delegationEndDate?.toIso8601String(),
    };
  }

  Map<String, dynamic> removeDelegation() {
    return <String, dynamic>{
      'temporaryOwner': email,
      'delegationStartDate': delegationStartDate?.toIso8601String(),
      'delegationEndDate': delegationEndDate?.toIso8601String(),
    };
  }

  factory TemporaryOwnerParams.fromJson(Map<String, dynamic> map) {
    return TemporaryOwnerParams(
      email: map['email'] as String,
      delegationStartDate: DateTime.fromMillisecondsSinceEpoch(map['startDelegationDate'] as int),
      delegationEndDate: DateTime.fromMillisecondsSinceEpoch(map['endDelegationDate'] as int),
    );
  }
}
