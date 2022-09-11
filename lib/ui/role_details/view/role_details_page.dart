import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/role_details/view/role_details_view.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/role_details_cubit.dart';

class RoleDetailsPage extends StatelessWidget {
  // final String role;
  final UserRoles userRole;

  const RoleDetailsPage({Key? key, required this.userRole}) : super(key: key);

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
