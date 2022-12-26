import 'package:bioplus/ui/admin/pages/visitor_log_book/view/logbook_view.dart';
import 'package:bioplus/ui/edec_forms/page/livestock_waybill/livestock_waybill.dart';
import 'package:flutter/material.dart';

import '../cubit/logbook_cubit.dart';

class LogbookPage extends StatelessWidget {
  const LogbookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogBookCubit(context),
      child: const LogbookView(),
    );
  }
}
