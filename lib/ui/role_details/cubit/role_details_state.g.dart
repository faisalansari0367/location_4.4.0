// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_details_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleDetailsState _$RoleDetailsStateFromJson(Map<String, dynamic> json) =>
    RoleDetailsState(
      fields: (json['fields'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      licenseCategories: (json['licenseCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      userRoleDetails: json['userRoleDetails'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      isLoading: json['isLoading'] as bool? ?? false,
      isConnected: json['isConnected'] as bool? ?? true,
      userSpecies: json['userSpecies'] == null
          ? null
          : UserSpecies.fromJson(json['userSpecies'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoleDetailsStateToJson(RoleDetailsState instance) =>
    <String, dynamic>{
      'fields': instance.fields,
      'licenseCategories': instance.licenseCategories,
      'userRoleDetails': instance.userRoleDetails,
      'isLoading': instance.isLoading,
      'isConnected': instance.isConnected,
      'userSpecies': instance.userSpecies,
    };
