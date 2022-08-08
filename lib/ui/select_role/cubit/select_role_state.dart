// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'select_role_cubit.dart';
class SelectRoleState extends Equatable {
  final List<String> roles;

  final bool isLoading;
  final User user;

  const SelectRoleState({this.isLoading = true, this.roles = const [],required this.user});


  @override
  List<Object> get props => [roles, isLoading, user];

  SelectRoleState copyWith({
    List<String>? roles,
    bool? isLoading,
    User? user,
  }) {
    return SelectRoleState(
      roles: roles ?? this.roles,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}

