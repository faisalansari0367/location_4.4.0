// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/forms/view/forms_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cubit/forms_cubit_cubit.dart';

class FormsPage extends StatelessWidget {
  final List<String>? questions;
  // final ValueChanged<Map<String, String>> onSubmit;
  final String? title;
  const FormsPage({
    Key? key,
    this.questions,
    // required this.onSubmit,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      key: UniqueKey(),
      create: (context) => FormsCubit(
        // onSubmit: onSubmit,/
        // questions: questions,
        api: context.read<Api>(),
      ),
      child: const FormsView(),
    );
  }
}
