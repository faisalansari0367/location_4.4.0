import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/admin/pages/visitor_log_book/widget/logbook_details.dart';
import 'package:background_location/widgets/dialogs/dialog_layout.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../forms/view/global_questionnaire_form.dart';
import '../cubit/logbook_cubit.dart';
import '../cubit/logbook_state.dart';

class LogbookView extends StatefulWidget {
  const LogbookView({Key? key}) : super(key: key);

  @override
  State<LogbookView> createState() => _LogbookViewState();
}

class _LogbookViewState extends State<LogbookView> {
  // static const headers = ['id', 'Full Name', 'entry date', 'exit date', 'Zone', 'pic', 'form'];
  late User? _user;

  @override
  void initState() {
    _user = context.read<Api>().getUser();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LogBookCubit>();
    return BlocBuilder<LogBookCubit, LogBookState>(
      builder: (context, state) {
        return Scaffold(
          appBar: MyAppBar(
            elevation: 5,
            title: const Text('Visitor Log book'),
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  // child: DataTable(
                  //   columns: ['id', 'Full Name', 'entry date', 'exit date', 'Zone', 'pic', 'form']
                  //       .map((e) => _dataColumn(e.capitalize!))
                  //       .toList(),
                  //   rows: state.entries.map(_dataRow).toList(),
                  // ),
                  child: StreamBuilder<List<LogbookEntry>>(
                    stream: cubit.api.logbookRecordsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return DataTable(
                        dataRowHeight: 60,
                        columns: [
                          if (kDebugMode) 'id',
                          'Full Name',
                          'entry date',
                          'exit date',
                          'Zone',
                          'pic',
                          'Declaration'
                        ].map((e) => _dataColumn(e.capitalize!)).toList(),
                        rows: (snapshot.data ?? []).map((e) => _dataRow(e, snapshot.data!.indexOf(e), state)).toList(),
                        columnSpacing: 31,
                      );
                    },
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
  DataRow _dataRow(LogbookEntry item, int index, LogBookState state) {
    return DataRow(
      color: MaterialStateProperty.all(index % 2 == 0 ? Colors.grey.shade100 : Colors.white),
      // color: MaterialStateProperty.all(item.geofence?.color ?? Colors.transparent),
      cells: [
        if (kDebugMode) _dataCell(item.id.toString()),
        _dataCell('${item.user!.firstName!} ${item.user!.lastName}'),
        _dataCell('${MyDecoration.formatTime(item.enterDate)}\n${MyDecoration.formatDate(item.enterDate)}'),
        _dataCell('${MyDecoration.formatTime(item.exitDate)}\n${MyDecoration.formatDate(item.exitDate)}'),
        _dataCell(item.geofence?.name ?? ''),
        _dataCell(item.geofence?.pic ?? '', color: item.geofence?.color, isPic: true),

        // item.geofence.
        DataCell(
          (item.form.isNotEmpty)
              ? TextButton(
                  onPressed: () => Get.to(() => LogbookDetails(item: item)),
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('View'),
                )
              : GestureDetector(
                  // onTap: !isCurrentUser(context, item.id)
                  onTap: !(_user?.id == item.user!.id)
                      ? null
                      : () {
                          DialogService.showDialog(
                            child: DialogLayout(
                              child: Padding(
                                padding: kPadding,
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Gap(10.h),
                                    Text(
                                      'Do you want to complete the declaration form now for ${item.user!.firstName} ${item.user!.lastName} into location ${item.geofence?.name}?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Gap(20.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: MyElevatedButton(
                                            onPressed: () async {
                                              Get.back();
                                            },
                                            // child: const Text('No'),
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                        ),
                                        Gap(20.w),
                                        Expanded(
                                          child: MyElevatedButton(
                                            onPressed: () async {
                                              Get.back();
                                              Get.to(
                                                () => GlobalQuestionnaireForm(
                                                  zoneId: item.geofence!.id!.toString(),
                                                  logrecordId: item.id,
                                                ),
                                              );
                                            },
                                            // text: 'Yes',
                                            color: Colors.green,
                                            child: Text(
                                              'Yes',
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                  child: Text(
                    'Unregistered'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  bool isCurrentUser(context, int? id) {
    return id == context.read<LogBookCubit>().state.user.id;
  }

  // _datacell
  DataCell _dataCell(String data, {Color? color = Colors.black, bool isPic = false}) {
    return DataCell(
      Container(
        padding: EdgeInsets.symmetric(horizontal: isPic ? 10.w : 0.w, vertical: 5.h),
        decoration: isPic
            ? BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
              )
            : null,
        child: Text(
          data,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: !isPic
                ? null
                : color!.computeLuminance() <= 0.5
                    ? Colors.white
                    : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  DataColumn _dataColumn(String name) {
    return DataColumn(
      numeric: false,
      label: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        // alignment: Alignment.center,
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget itemBuilder(BuildContext p1, int index) {
  //   final item = p1.read<LogBookCubit>().state.entries[index];

  //   return ListTile(
  //     title: Text(
  //       item.id.toString(),
  //       textAlign: TextAlign.center,
  //       style: TextStyle(
  //         color: Colors.grey.shade900,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //     subtitle: Text(
  //       MyDecoration.formatDate(item.updatedAt),
  //       style: TextStyle(
  //         color: Colors.grey.shade600,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //     // onTap: hasChildrens(item.form) ? null : () => Get.to(() => LogbookDetails(form: item.form)),
  //     // trailing: !hasChildrens(item.form) ? Icon(Icons.chevron_right) : SizedBox.shrink(),
  //   );
  // }

  bool hasChildrens(LogbookFormField? item) {
    if (item == null) return true;
    // if (item.form is! Map) return true;
    // if (item is Map) return true;
    return false;
  }

  // TableRow _tableRow(List<String> list) {
  //   return TableRow(
  //     children: [
  //       for (var item in list)
  //         TableCell(
  //           child: Text(item),
  //         ),
  //     ],
  //   );
  // }
}
