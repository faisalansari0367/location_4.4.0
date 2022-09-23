import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/widget/logbook_details.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../cubit/logbook_cubit.dart';
import '../cubit/logbook_state.dart';

class LogbookView extends StatefulWidget {
  const LogbookView({Key? key}) : super(key: key);

  @override
  State<LogbookView> createState() => _LogbookViewState();
}

class _LogbookViewState extends State<LogbookView> {
  static const headers = ['id', 'Full Name', 'entry date', 'exit date', 'Zone', 'pic', 'form'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogBookCubit, LogBookState>(
      builder: (context, state) {
        return Scaffold(
          appBar: MyAppBar(
            title: Text('Visitor Log book'),
            actions: [
              if (!state.isLoading)
                IconButton(
                  onPressed: () {
                    context.read<LogBookCubit>().generatePDf();
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.zero,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: state.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columns: ['id', 'Full Name', 'entry date', 'exit date', 'Zone', 'pic', 'form']
                              .map((e) => _dataColumn(e.capitalize!))
                              .toList(),
                          rows: state.entries.map((e) => _dataRow(e)).toList(),

                          columnSpacing: 31.w,

                          // children: [
                          //   _tableRow(['id', 'entry date', 'exit date', 'field name']),
                          //   for (var item in state.entries)
                          //     _tableRow(
                          //       [
                          //         item.id.toString(),
                          //         MyDecoration.formatDate(item.enterDate),
                          //         MyDecoration.formatDate(item.exitDate),
                          //         item.geofence?.name ?? ''
                          //       ],
                          //     )
                          // ],
                        ),
                      ),
                    ),
              // );
              // return MyListview<LogbookEntry>(
              //   // emptyWidget: Center(
              //   //   child: Text('No data found'),
              //   // ),
              //   onRetry: context.read<LogBookCubit>().getRecords,
              //   isLoading: state.isLoading,
              //   spacing: Container(color: Colors.grey.shade200, height: 2.h),
              //   data: state.entries,
              //   itemBuilder: itemBuilder,
            ),
          ),
        );
      },
    );
  }

  // DataRow _tableRow(data) {
  DataRow _dataRow(LogbookEntry item) {
    return DataRow(
      // color: MaterialStateProperty.all(item.geofence?.color ?? Colors.transparent),
      cells: [
        _dataCell(item.id.toString()),
        _dataCell('${item.user!.firstName!} ${item.user!.lastName}'),
        _dataCell(MyDecoration.formatTime(item.enterDate) + '\n' + MyDecoration.formatDate(item.enterDate)),
        _dataCell(MyDecoration.formatTime(item.exitDate) + '\n' + MyDecoration.formatDate(item.exitDate)),
        _dataCell(item.geofence?.name ?? ''),
        _dataCell(item.geofence?.pic ?? '', color: item.geofence?.color),

        // item.geofence.
        DataCell(
          (item.form.isNotEmpty)
              ? TextButton(
                  onPressed: () => Get.to(() => LogbookDetails(form: item.form)),
                  child: Text('View'),
                )
              : Text(''),
        ),
      ],
    );
  }

  // _datacell
  DataCell _dataCell(String data, {Color? color = Colors.black}) {
    return DataCell(
      Text(
        data,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: color?.withOpacity(0.7),
        ),
      ),
    );
  }

  DataColumn _dataColumn(String name) {
    return DataColumn(
      label: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.w,
          fontWeight: FontWeight.bold,
        ),
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
        MyDecoration.formatDate(item.updatedAt),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
      ),
      // onTap: hasChildrens(item.form) ? null : () => Get.to(() => LogbookDetails(form: item.form)),
      // trailing: !hasChildrens(item.form) ? Icon(Icons.chevron_right) : SizedBox.shrink(),
    );
  }

  bool hasChildrens(LogbookFormField? item) {
    if (item == null) return true;
    // if (item.form is! Map) return true;
    // if (item is Map) return true;
    return false;
  }

  TableRow _tableRow(List<String> list) {
    return TableRow(
      children: [
        for (var item in list)
          TableCell(
            child: Text(item),
          ),
      ],
    );
  }
}
