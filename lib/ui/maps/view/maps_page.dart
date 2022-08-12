import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_notification/local_notification.dart';

import '../cubit/maps_cubit.dart';
import 'maps_view.dart';


class MapsPage extends StatelessWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapsCubit(context.read<NotificationService>()),
      child: const MapsView(),
    );
  }
}
