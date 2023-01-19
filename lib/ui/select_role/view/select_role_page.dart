// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/services/notifications/push_notifications.dart';
import 'package:bioplus/ui/select_role/cubit/select_role_cubit.dart';
import 'package:bioplus/ui/select_role/view/select_role_view.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectRolePage extends StatelessWidget {
  final bool showBackArrow;
  final VoidCallback? onRoleUpdated;
  const SelectRolePage({
    super.key,
    this.showBackArrow = false,
    this.onRoleUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectRoleCubit(
        context.read<Api>(),
        context.read<LocalApi>(),
        context.read<PushNotificationService>(),
        onRoleUpdated: onRoleUpdated,
      ),
      child: SelectRoleView(
        showBackArrow: showBackArrow,
      ),
    );
  }
}
