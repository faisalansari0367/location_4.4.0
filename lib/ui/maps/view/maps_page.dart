import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_notification/local_notification.dart';

import '../cubit/maps_cubit.dart';
import '../location_service/maps_repo.dart';
import 'maps_view.dart';

class MapsPage extends StatelessWidget {
  final bool fromDrawer;
  const MapsPage({Key? key, this.fromDrawer = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapsCubit(
        context.read<NotificationService>(),
        context.read<MapsRepo>(),
      ),
      child: MapsView(fromDrawer: fromDrawer),
    );
  }
}
