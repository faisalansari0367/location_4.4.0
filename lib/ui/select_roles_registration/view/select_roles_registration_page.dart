import 'package:bioplus/ui/select_roles_registration/view/select_roles_registration_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cubit/select_roles_registration_cubit.dart';

class SelectRolesRegistrationPage extends StatelessWidget {
  final List<String> allowedRoles;
  final bool isFromRegistration;
  final VoidCallback? onRoleUpdated;
  const SelectRolesRegistrationPage({
    Key? key,
    this.allowedRoles = const [],
    this.onRoleUpdated,
    this.isFromRegistration = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RolesRegistrationCubit(
        context,
        isFromRegistration: isFromRegistration,
        onRoleUpdated: onRoleUpdated,
      ),
      child: SelectRolesRegistrationView(),
    );
  }
}
