import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/admin/pages/visitor_log_book/widget/logbook_details.dart';
import 'package:bioplus/ui/edec_forms/page/livestock_waybill/livestock_waybill.dart';
import 'package:bioplus/ui/forms/forms_page.dart';
import 'package:bioplus/ui/maps/models/polygon_model.dart';
import 'package:bioplus/widgets/dialogs/dialogs.dart';
import 'package:bioplus/widgets/empty_screen.dart';
import 'package:bioplus/widgets/listview/infinite_table.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return Consumer<LogBookCubit>(
      builder: (context, provider, child) {
        final state = provider.state;

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
                stream: cubit.localApi.logbookRecordsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return Center(
                      heightFactor: 2,
                      widthFactor: 1.1,
                      child: const EmptyScreen(
                        message: 'No Log Records Found',
                      ),
                    );
                  }

                  return DataTable(
                    dataRowHeight: 60,
                    columns: cubit.list.map((e) => _dataColumn(e.toUpperCase())).toList(),
                    rows: _buildRows(snapshot.data ?? [], state),
                    columnSpacing: 30,
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

  Color _zebraColor(int index) {
    return index % 2 == 0 ? Colors.grey.shade100 : Colors.white;
  }

  // DataRow _tableRow(data) {
  DataRow _dataRow(LogbookEntry item, int index, LogBookState state) {
    return DataRow(
      color: MaterialStateProperty.all(_zebraColor(index)),
      cells: [
        if (kDebugMode) _dataCell(item.id.toString()),
        _dataCell('${item.user?.fullName}', isOffline: item.isOffline),
        // _dataCell('${MyDecoration.formatTime(item.enterDate)}\n${MyDecoration.formatDate(item.enterDate)}'),
        // _dataCell(MyDecoration())
        _dataCell(_dateAndTime(item.enterDate)),
        _dataCell(_dateAndTime(item.exitDate)),
        _dataCell(item.geofence?.name ?? ''),
        _dataCell(item.geofence?.pic ?? item.user?.ngr ?? '',
            color: item.geofence?.color, isPic: item.geofence?.pic != null),
        _dataCell((item.user?.postcode == null ? '' : (item.user?.postcode).toString()),
            color: item.geofence?.color, isPic: false),
        _buildFormButton(item),
      ],
    );
  }

  String _dateAndTime(DateTime? date) {
    return '${MyDecoration.formatTime(date)}\n${MyDecoration.formatDate(date)}';
  }

  DataCell _buildFormButton(LogbookEntry item) {
    return DataCell(
      (item.form?.isNotEmpty ?? false)
          ? TextButton(
              onPressed: () => Get.to(() => LogbookDetails(item: item)),
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('View'),
            )
          : TextButton(
              onPressed: !(_user?.id == item.user!.id)
                  ? () => _notAllowedDeclarationForm()
                  : () => _completeDeclarationDialog(item),
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

  Future<void> _notAllowedDeclarationForm() {
    return DialogService.showDialog(
      child: ErrorDialog(
        message: 'You are not allowed to complete declaration form for this user',
        onTap: Get.back,
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
                              points: [],
                            ),
                          ),
                        );
                      },
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
  DataCell _dataCell(String data, {Color? color = Colors.black, bool isPic = false, bool isOffline = false}) {
    return DataCell(
      Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: isPic ? 10.w : 0.w, vertical: 5.h),
            decoration: isPic
                ? BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(5),
                  )
                : null,
            child: Row(
              children: [
                if (isOffline) _buildDot(),
                Text(
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildDot() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      margin: EdgeInsets.only(right: 5.w),
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
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
