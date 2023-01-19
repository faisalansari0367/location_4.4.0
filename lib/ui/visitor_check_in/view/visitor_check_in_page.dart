import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/visitor_check_in/cubit/visitor_check_in_cubit.dart';
import 'package:bioplus/ui/visitor_check_in/view/visitor_check_in_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VisitorCheckInPage extends StatelessWidget {
  const VisitorCheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VisitorCheckInCubit(api: context.read<Api>()),
      child: const VisitorCheckInView(),
    );
  }
}
