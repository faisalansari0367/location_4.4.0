// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UsersState extends Equatable {
  final List<UserData> users;
  final String? filter;
  final Map<int, UserStatus> status;
  final TextEditingController controller;
  final List<String> roles;
  final String? selectRole;
  final bool isLoading;
  UsersState({
    required this.controller,
    this.selectRole,
    this.roles = const [],
    this.filter,
    this.status = const {},
    this.users = const [],
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [users, isLoading, filter, roles, selectRole];

  UsersState copyWith({
    List<UserData>? users,
    String? filter,
    Map<int, UserStatus>? status,
    List<String>? roles,
    bool? isLoading,
    String? selectRole,
    TextEditingController? controller,
  }) {
    return UsersState(
      controller: controller ?? this.controller,
      selectRole: selectRole ?? this.selectRole,
      users: users ?? this.users,
      filter: filter ?? this.filter,
      status: status ?? this.status,
      roles: roles ?? this.roles,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
