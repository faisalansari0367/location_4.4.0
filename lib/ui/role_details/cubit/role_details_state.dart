// ignore_for_file: public_member_api_docs, sort_constructors_first
// part of 'role_details_cubit.dart';
import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/role_details/models/field_data.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'role_details_state.g.dart';

@JsonSerializable()
class RoleDetailsState extends Equatable {
  @JsonKey(ignore: true)
  final List<FieldData> fieldsData;
  final List<String> fields;
  final List<String> licenseCategories;

  final Map<String, dynamic> userRoleDetails;
  final bool isLoading;
  final bool isConnected;
  final UserSpecies? userSpecies;

  const RoleDetailsState({
    this.fieldsData = const [],
    this.fields = const [],
    this.licenseCategories = const [],
    this.userRoleDetails = const <String, dynamic>{},
    this.isLoading = false,
    this.isConnected = true,
    this.userSpecies,
  });

  @override
  List<Object> get props => [
        isLoading,
        fields,
        userRoleDetails,
        fieldsData,
        isConnected,
        if (userSpecies != null) userSpecies!,
        licenseCategories,
      ];

  RoleDetailsState copyWith({
    List<FieldData>? fieldsData,
    List<String>? fields,
    List<String>? licenseCategories,
    Map<String, dynamic>? userRoleDetails,
    bool? isLoading,
    bool? isConnected,
    UserSpecies? userSpecies,
  }) {
    return RoleDetailsState(
      fieldsData: fieldsData ?? this.fieldsData,
      fields: fields ?? this.fields,
      licenseCategories: licenseCategories ?? this.licenseCategories,
      userRoleDetails: userRoleDetails ?? this.userRoleDetails,
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      userSpecies: userSpecies ?? this.userSpecies,
    );
  }

  factory RoleDetailsState.fromJson(Map<String, dynamic> json) =>
      _$RoleDetailsStateFromJson(json);

  Map<String, dynamic> toJson() => _$RoleDetailsStateToJson(this);
}
