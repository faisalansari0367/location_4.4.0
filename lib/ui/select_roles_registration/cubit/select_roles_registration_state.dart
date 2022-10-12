// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:background_location/ui/select_roles_registration/models/select_role_model.dart';

class SelectRolesRegistrationState {
  final List<SelectRoleModel> rolesList;

  SelectRolesRegistrationState({
    required this.rolesList,
  });

  SelectRolesRegistrationState copyWith({
    List<SelectRoleModel>? rolesList,
  }) {
    return SelectRolesRegistrationState(
      rolesList: rolesList ?? this.rolesList,
    );
  }
}
