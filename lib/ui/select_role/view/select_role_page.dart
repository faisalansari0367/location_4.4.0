import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/select_role/cubit/select_role_cubit.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'select_role_view.dart';

class SelectRolePage extends StatelessWidget {
  const SelectRolePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectRoleCubit(context.read<Api>()),
      child: const SelectRoleView(),
    );
  }
}
