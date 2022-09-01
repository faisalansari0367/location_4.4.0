import 'package:api_repo/api_repo.dart';
import 'package:background_location/widgets/expanded_tile.dart';
import 'package:background_location/widgets/listview/my_listview.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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

    return ExpandedTile(
      crossAxisAlignment: CrossAxisAlignment.start,
      title: Text(
        item.id.toString(),
        style: TextStyle(
          color: Colors.grey.shade900,
          fontWeight: FontWeight.w600,
        ),
      ),
      // hideArrow: item.form != null || (item.form?.isNotEmpty ?? false),
      hideArrow: hasChildrens(item),
      subtitle: Text(
        item.formmatedDate(),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: SizedBox.shrink(),
      children: childrens(item.form),
      // children: [null, []].contains(item.form) ? [] : [
      //   if(item.form is Map) ...(item.form as Map).forEach((key, value) {

      //   })l
      // ],
    );
  }

  bool hasChildrens(Entries item) {
    if (item.form == null) return true;
    if (item.form is! Map) return true;
    if (item is Map) return true;
    return false;
  }

  List<Widget> childrens(dynamic form) {
    final list = <Widget>[];
    if (form == null) return list;
    if (form is! Map) list;
    if (form is Map) {
      list.add(Divider());
      form.forEach((key, value) {
        list.add(_radioButton(key, value));
        list.add(Divider());
      });
    }
    return list;
  }

  Container _radioButton(String question, bool answer) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          // borderRadius: kBorderRadius,
          // border: Border.all(
          //   color: Colors.grey.shade300,
          // ),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.h,
              color: Colors.grey.shade900,
            ),
          ),
          Gap(10.h),
          // Icon(
          //   value ? Icons.check : Icons.clear,
          //   color: !value ? Colors.red : Colors.teal,
          // ),
          Text(
            answer ? 'YES' : "NO",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.h,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _button() {

  // }
}
