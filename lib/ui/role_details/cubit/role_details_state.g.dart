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
      userRoleDetails: json['userRoleDetails'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
      isLoading: json['isLoading'] as bool? ?? false,
    );

Map<String, dynamic> _$RoleDetailsStateToJson(RoleDetailsState instance) =>
    <String, dynamic>{
      'fields': instance.fields,
      'userRoleDetails': instance.userRoleDetails,
      'isLoading': instance.isLoading,
    };
