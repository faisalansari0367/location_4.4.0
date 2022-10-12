import 'package:background_location/ui/select_roles_registration/view/select_roles_registration_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cubit/select_roles_registration_cubit.dart';

class SelectRolesRegistrationPage extends StatelessWidget {
  final List<String> allowedRoles;
  final bool isFromRegistration;
  const SelectRolesRegistrationPage({Key? key, this.allowedRoles = const [], this.isFromRegistration = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RolesRegistrationCubit(context, isFromRegistration: isFromRegistration),
      child: SelectRolesRegistrationView(),
    );
  }
}
