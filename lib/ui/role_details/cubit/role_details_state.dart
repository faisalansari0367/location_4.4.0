// ignore_for_file: public_member_api_docs, sort_constructors_first
// part of 'role_details_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/field_data.dart';

part 'role_details_state.g.dart';

@JsonSerializable()
class RoleDetailsState extends Equatable {
  @JsonKey(ignore: true)
  final List<FieldData> fieldsData;
  final List<String> fields;
  final Map<String, dynamic> userRoleDetails;
  final bool isLoading;

  const RoleDetailsState({
    this.fieldsData = const [],
    this.fields = const [],
    this.userRoleDetails = const <String, dynamic>{},
    this.isLoading = false,
  });

  @override
  List<Object> get props => [isLoading, fields, userRoleDetails, fieldsData];

  RoleDetailsState copyWith({
    List<FieldData>? fieldsData,
    List<String>? fields,
    Map<String, dynamic>? userRoleDetails,
    bool? isLoading,
  }) {
    return RoleDetailsState(
      fieldsData: fieldsData ?? this.fieldsData,
      fields: fields ?? this.fields,
      userRoleDetails: userRoleDetails ?? this.userRoleDetails,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory RoleDetailsState.fromJson(Map<String, dynamic> json) => _$RoleDetailsStateFromJson(json);

  Map<String, dynamic> toJson() => _$RoleDetailsStateToJson(this);
}
