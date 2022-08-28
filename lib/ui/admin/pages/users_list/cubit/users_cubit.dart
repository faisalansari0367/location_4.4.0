import 'package:api_repo/api_repo.dart';
import 'package:background_location/helpers/callback_debouncer.dart';
import 'package:background_location/ui/admin/pages/users_list/cubit/users_state.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class UsersCubit extends Cubit<UsersState> {
  final Api api;

  UsersCubit(this.api) : super(UsersState()) {
    fetchUsers();
    getRoles();
  }

  final controller = TextEditingController();

  void setFilter(String filter) {
    emit(state.copyWith(filter: filter));
    fetchUsers();
  }

  final debouncer = CallbackDebouncer(400.milliseconds);
  void onSearch(String text) {
    debouncer.call(() {
      fetchUsers(q: text);
    });
  }

  void setCurrentRole(String role) {
    emit(state.copyWith(selectRole: role));
    controller.text = role;
    fetchUsers();
  }

  void setStatus(String status, int id) {
    final _status = state.status;
    final result = UserStatus.values.where((element) => element.name == (status).toLowerCase());
    if (result.isEmpty) _status[id] = UserStatus.inactive;
    _status[id] = result.first;
    emit(state.copyWith(status: _status));
  }

  void getRoles() async {
    final result = await api.getUserRoles();
    result.when(
      success: (data) => emit(state.copyWith(roles: data.roles)),
      failure: (e) => DialogService.failure(error: e),
    );
  }

  String camelCase(String text) {
    // String text = 'camelCase';
    RegExp exp = RegExp(r'(?<=[a-z])[A-Z]');
    String result = text.replaceAllMapped(exp, (Match m) => ('_' + m.group(0)!)).toLowerCase();
    return result;
  }

  // String _upperCaseFirstLetter(String word) {
  //   return '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
  // }

  // String _getSnakeCase(String text,  {String separator: '_'}) {
  //   List<String> words = text.map((word) => word.toLowerCase()).toList();

  //   return words.join(separator);
  // }

  Future<void> fetchUsers({String? q}) async {
    emit(state.copyWith(isLoading: true));
    final map = {'role': state.selectRole};
    // if (state.filter != null) {
    // }
    map[(state.filter?.camelCase) ?? 'firstName'] = q;
    final result = await api.getUsers(queryParams: map);
    result.when(
      success: (s) => emit(state.copyWith(users: s.users)),
      failure: (error) => DialogService.failure(error: error),
    );
    emit(state.copyWith(isLoading: false));
  }
}
