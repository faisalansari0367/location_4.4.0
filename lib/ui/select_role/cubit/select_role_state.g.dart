// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_role_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectRoleState _$SelectRoleStateFromJson(Map<String, dynamic> json) =>
    SelectRoleState(
      isLoading: json['isLoading'] as bool? ?? true,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SelectRoleStateToJson(SelectRoleState instance) =>
    <String, dynamic>{
      'roles': instance.roles,
      'isLoading': instance.isLoading,
      'user': instance.user,
    };
