// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/role_details/cubit/role_details_cubit.dart';
import 'package:bioplus/ui/role_details/view/role_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleDetailsPage extends StatelessWidget {
  // final String role;
  final UserRoles userRole;

  const RoleDetailsPage({
    super.key,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoleDetailsCubit(
        userRole.role,
        context.read<LocalApi>(),
        context.read<Api>(),
        fields: userRole.fields,
      ),
      child: const RoleDetailsView(),
    );
  }
}
