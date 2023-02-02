import 'package:bioplus/ui/visitor_log_book/cubit/logbook_cubit.dart';
import 'package:bioplus/ui/visitor_log_book/view/logbook_view.dart';
import 'package:bioplus/ui/edec_forms/page/livestock_waybill/livestock_waybill.dart';
import 'package:flutter/material.dart';

class LogbookPage extends StatelessWidget {
  const LogbookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogBookCubit(context),
      child: const LogbookView(),
    );
  }
}
