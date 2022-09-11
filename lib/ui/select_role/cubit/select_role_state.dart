// ignore_for_file: public_member_api_docs, sort_constructors_first
// part of 'select_role_cubit.dart';
import 'package:api_repo/api_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

// part 'select_role_state.g.dart';

@JsonSerializable()
class SelectRoleState extends Equatable {
  final List<UserRoles> roles;

  final bool isLoading;
  final bool isConnected;

  final User user;

  const SelectRoleState({this.isConnected = true, this.isLoading = true, this.roles = const [], required this.user});

  @override
  List<Object> get props => [roles, isLoading, user, isConnected];

  SelectRoleState copyWith({
    List<UserRoles>? roles,
    bool? isLoading,
    bool? isConnected,
    User? user,
  }) {
    return SelectRoleState(
      roles: roles ?? this.roles,
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      user: user ?? this.user,
    );
  }

  // factory SelectRoleState.fromJson(Map<String, dynamic> json) => _$SelectRoleStateFromJson(json);

  // Map<String, dynamic> toJson() => _$SelectRoleStateToJson(this);
}
