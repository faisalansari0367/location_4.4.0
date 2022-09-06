import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/widget/logbook_details.dart';
import 'package:background_location/widgets/listview/my_listview.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../cubit/logbook_cubit.dart';
import '../cubit/logbook_state.dart';

class LogbookView extends StatelessWidget {
  const LogbookView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text('Visitor Log book'),
      ),
      body: BlocBuilder<LogBookCubit, LogBookState>(
        builder: (context, state) {
          return MyListview<Entries>(
            isLoading: state.isLoading,
            spacing: Container(color: Colors.grey.shade200, height: 2.h),
            data: state.entries,
            itemBuilder: itemBuilder,
          );
        },
      ),
    );
  }

  Widget itemBuilder(BuildContext p1, int index) {
    final item = p1.read<LogBookCubit>().state.entries[index];
    return ListTile(
      title: Text(
        item.id.toString(),
        style: TextStyle(
          color: Colors.grey.shade900,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        item.formmatedDate(),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: hasChildrens(item) ? null : () => Get.to(() => LogbookDetails(form: item.form)),
      trailing: !hasChildrens(item) ? Icon(Icons.chevron_right) : SizedBox.shrink(),
    );
  }

  bool hasChildrens(Entries item) {
    if (item.form == null) return true;
    if (item.form is! Map) return true;
    if (item is Map) return true;
    return false;
  }
}
