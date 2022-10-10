// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:background_location/ui/select_roles_registration/models/select_role_model.dart';

class SelectRolesRegistrationState {
  final Set<SelectRoleModel> selectedRoles;
  final List<SelectRoleModel> rolesList;

  SelectRolesRegistrationState({
    required this.rolesList,
    required this.selectedRoles,
  });

  SelectRolesRegistrationState copyWith({
    Set<SelectRoleModel>? selectedRoles,
    List<SelectRoleModel>? rolesList,
  }) {
    return SelectRolesRegistrationState(
      selectedRoles: selectedRoles ?? this.selectedRoles,
      rolesList: rolesList ?? this.rolesList,
    );
  }
}
