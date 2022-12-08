import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/admin/pages/visitor_log_book/widget/logbook_details.dart';
import 'package:bioplus/ui/forms/forms_page.dart';
import 'package:bioplus/ui/maps/models/polygon_model.dart';
import 'package:bioplus/widgets/dialogs/dialog_layout.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/listview/infinite_table.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    final cubit = context.read<LogBookCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // cubit.getLogbookRecords();
      cubit.refreshIndicatorKey.currentState?.show();
    });
  }

  // static const list = [
  //   if (kDebugMode) 'id',
  //   'Full Name',
  //   'entry date',
  //   'exit date',
  //   'Zone',
  //   'PIC/NGR',
  //   'Post Code',
  //   'Declaration'
  // ];

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
                  icon: const Icon(
                    Icons.picture_as_pdf,
                    size: 30,
                  ),
                  onPressed: context.read<LogBookCubit>().generatePDf,
                ),
              Gap(10),
              if (!state.isLoading)
                IconButton(
                  icon: Image.asset(
                    'assets/icons/export.png',
                    width: 30,
                  ),
                  onPressed: context.read<LogBookCubit>().generateCsv,
                ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: cubit.getRecords,
            key: cubit.refreshIndicatorKey,
            child: InfiniteTable(
              hasReachedMax: state.hasReachedMax,
              onRefresh: cubit.onRefresh,
              // table: DataTable(
              //   dataRowHeight: 60,
              //   columns: cubit.list.map((e) => _dataColumn(e.toUpperCase())).toList(),
              //   rows: _buildRows(state.entries, state),
              //   columnSpacing: 31,
              // ),
              table: StreamBuilder<List<LogbookEntry>>(
                stream: cubit.api.logbookRecordsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return DataTable(
                    dataRowHeight: 60,
                    columns: cubit.list.map((e) => _dataColumn(e.toUpperCase())).toList(),
                    rows: _buildRows(snapshot.data ?? [], state),
                    columnSpacing: 31,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  List<DataRow> _buildRows(List<LogbookEntry> data, LogBookState state) {
    List<DataRow> rows = [];
    for (var i = 0; i < data.length; i++) {
      rows.add(_dataRow(data[i], i, state));
    }
    return rows;
  }

  // DataRow _tableRow(data) {
  DataRow _dataRow(LogbookEntry item, int index, LogBookState state) {
    return DataRow(
      color: MaterialStateProperty.all(
        index % 2 == 0 ? Colors.grey.shade100 : Colors.white,
      ),
      cells: [
        if (kDebugMode) _dataCell(item.id.toString()),
        _dataCell('${item.user?.firstName} ${item.user?.lastName}'),
        _dataCell('${MyDecoration.formatTime(item.enterDate)}\n${MyDecoration.formatDate(item.enterDate)}'),
        _dataCell('${MyDecoration.formatTime(item.exitDate)}\n${MyDecoration.formatDate(item.exitDate)}'),
        _dataCell(item.geofence?.name ?? ''),
        _dataCell(item.geofence?.pic ?? item.user?.ngr ?? '',
            color: item.geofence?.color, isPic: item.geofence?.pic != null),
        _dataCell((item.user?.postcode == null ? '' : (item.user?.postcode).toString()),
            color: item.geofence?.color, isPic: false),
        _buildFormButton(item),
      ],
    );
  }

  DataCell _buildFormButton(LogbookEntry item) {
    return DataCell(
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
              onTap: !(_user?.id == item.user!.id) ? null : () => _completeDeclarationDialog(item),
              child: Text(
                'Unregistered'.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  Future<dynamic> _completeDeclarationDialog(LogbookEntry item) {
    return DialogService.showDialog(
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
                      onPressed: () async => Get.back(),
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
                        // final PolygonModel polygonModel = PolygonModel.fromLocalJson(item.toJson());
                        Get.back();
                        Get.to(
                          () => FormsPage(
                            zoneId: item.geofence!.id!.toString(),
                            logRecordId: item.id,
                            logRecord: item,
                            polygon: PolygonModel(
                              id: item.id.toString(),
                              name: item.geofence!.name!,
                              color: item.geofence!.color!,
                              pic: item.geofence!.pic,
                              companyOwner: item.geofence?.companyOwner ?? '',
                              createdAt: item.createdAt,
                              updatedAt: item.updatedAt,
                              createdBy: item.user,
                              // TODO: check if this is correct
                              points: [],
                            ),
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
  }

  bool isCurrentUser(context, int? id) => id == context.read<LogBookCubit>().state.user.id;

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
                : (color ?? Colors.transparent).computeLuminance() <= 0.5
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
      label: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
