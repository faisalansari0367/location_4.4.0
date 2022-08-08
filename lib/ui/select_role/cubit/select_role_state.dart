// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'select_role_cubit.dart';
class SelectRoleState extends Equatable {
  final List<String> roles;
  final bool isLoading;
  final String userName;

  const SelectRoleState({this.isLoading = true, this.roles = const [], this.userName = ''});


  @override
  List<Object> get props => [roles, isLoading, userName];

  SelectRoleState copyWith({
    List<String>? roles,
    bool? isLoading,
    String? userName,
  }) {
    return SelectRoleState(
      roles: roles ?? this.roles,
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
    );
  }
}

