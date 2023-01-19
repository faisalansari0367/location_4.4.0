import 'package:bioplus/ui/select_roles_registration/cubit/select_roles_registration_cubit.dart';
import 'package:bioplus/ui/select_roles_registration/view/select_roles_registration_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectRolesRegistrationPage extends StatelessWidget {
  final List<String> allowedRoles;
  final bool isFromRegistration;
  final VoidCallback? onRoleUpdated;
  const SelectRolesRegistrationPage({
    super.key,
    this.allowedRoles = const [],
    this.onRoleUpdated,
    this.isFromRegistration = true,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RolesRegistrationCubit(
        context,
        isFromRegistration: isFromRegistration,
        onRoleUpdated: onRoleUpdated,
      ),
      child: const SelectRolesRegistrationView(),
    );
  }
}
