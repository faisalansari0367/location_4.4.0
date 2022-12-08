import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/admin/pages/visitor_log_book/view/logbook_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/logbook_cubit.dart';

class LogbookPage extends StatelessWidget {
  const LogbookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogBookCubit(api: context.read<Api>()),
      child: const LogbookView(),
    );
  }
}
