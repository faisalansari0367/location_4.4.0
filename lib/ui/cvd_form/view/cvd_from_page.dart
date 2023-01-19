import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/cvd_form/cubit/cvd_cubit.dart';
import 'package:bioplus/ui/cvd_form/view/cvd_form_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CvdFormPage extends StatelessWidget {
  const CvdFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CvdCubit(
        api: context.read<Api>(),
        localApi: context.read<LocalApi>(),
      ),
      child: const CvdFormView(),
    );
  }
}
