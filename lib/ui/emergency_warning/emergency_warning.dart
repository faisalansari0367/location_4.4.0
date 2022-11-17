import 'package:api_repo/api_repo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/maps/view/maps_page.dart';
import 'package:background_location/widgets/empty_screen.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../widgets/dialogs/dialog_layout.dart';
import '../../widgets/dialogs/dialog_service.dart';
import '../maps/location_service/maps_repo.dart';
import '../maps/models/polygon_model.dart';
import '../maps/widgets/geofences_list/geofence_card.dart';
import '../maps/widgets/geofences_list/geofences_view.dart';

class EmergencyWarning extends StatefulWidget {
  const EmergencyWarning({Key? key}) : super(key: key);

  @override
  State<EmergencyWarning> createState() => _EmergencyWarningState();
}

class _EmergencyWarningState extends State<EmergencyWarning> {
  final selectedZones = Set<int>();
  late Stream<List<PolygonModel>> _stream;
  FilterType filterType = FilterType.created_by_me;
  bool hasPolygon = true;
  UserData? userData;
  late MapsRepo _mapsRepo;

  setFilter() {
    setState(() {
      filterType = filterType == FilterType.created_by_me ? FilterType.all : FilterType.created_by_me;
    });
  }

  @override
  void initState() {
    userData = context.read<Api>().getUserData();
    _mapsRepo = context.read<MapsRepo>();
    _stream = _mapsRepo.polygonStream;
    _getPolygon();
    filterPolygons();
    super.initState();
  }

  Future<void> _getPolygon() async {
    if (!_mapsRepo.hasPolygons) {
      _mapsRepo.getAllPolygon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: AutoSizeText(
          'Emergency Warning',
          maxLines: 1,
          style: context.textTheme.headline6?.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 28.sp,
          ),
        ),
        centreTitle: true,
      ),
      bottomNavigationBar: hasPolygon ? _bottomNavbar(context) : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w),
        child: hasPolygon
            ? _buildBody(context)
            : Center(
                child: EmptyScreen(
                  message: 'You have not created any geofences.\nPlease contact the owner',
                  subWidget: MyElevatedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 24.w,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    width: 50.width,
                    onPressed: () async => Get.to(() => MapsPage()),
                  ),
                ),
              ),
      ),
    );
  }

  Column _buildBody(BuildContext context) {
    return Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/icons/warning_icon.png',
                    height: 100,
                  ),
                ),
                Text(
                  'Select A Location',
                  style: context.textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(20.h),
                if (userData?.role == 'Admin') ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        _buildFilters(context),
                        Gap(10.h),
                      ],
                    ),
                  ),
                ],
                Expanded(
                  child: StreamBuilder<List<PolygonModel>>(
                    stream: filterPolygons(),
                    builder: (context, snapshot) {
                      // hasPolygon = snapshot.hasData && snapshot.data!.isNotEmpty;
                      // setState(() {});
                      return Scrollbar(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => Gap(10.h),
                          padding: kPadding,
                          itemCount: sort(snapshot.data ?? []).length,
                          itemBuilder: (context, index) {
                            final fence = snapshot.data![index];
                            return GeofenceCard(
                              onTap: () {
                                final ids = selectedZones.where((element) => element == int.parse(fence.id!));
                                if (ids.isEmpty) {
                                  selectedZones.add(int.parse(fence.id!));
                                } else {
                                  selectedZones.remove(int.parse(fence.id!));
                                }
                                setState(() {});
                              },
                              isSelected: selectedZones.contains(int.parse(fence.id!)),
                              item: fence,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
  }

  Widget _bottomNavbar(BuildContext context) {
    return Container(
      height: 100,
      decoration: MyDecoration.decoration(),
      child: SizedBox(
        child: Center(
          child: MyElevatedButton(
            onPressed: () async {
              await _warningDialog(context);
            },
            width: 90.width,
            color: Colors.red,
            height: 60.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Send Notification',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp,
                    color: Colors.white,
                  ),
                ),
                Gap(20.w),
                Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildFilters(BuildContext context) {
    return Row(
      children: [
        Text(
          'Filter by',
          style: TextStyle(
            fontSize: 15.h,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        ...FilterType.values
            .map(
              (e) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: InputChip(
                  selected: filterType == e,
                  backgroundColor: Colors.grey.shade200,
                  selectedColor: context.theme.primaryColor.withOpacity(1),
                  // elevation: 5,
                  onPressed: setFilter,
                  checkmarkColor: filterType == e ? Colors.white : Colors.grey,

                  label: Text(
                    e.name.replaceAll('_', ' ').capitalize!,
                    style: TextStyle(
                      fontSize: 15.h,
                      color: filterType == e ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            )
            .toList()
      ],
    );
  }

  List<PolygonModel> sort(List<PolygonModel>? list) {
    if (list == null) return [];
    if (list.isEmpty) return [];
    return list..sort((a, b) => a.name.compareTo(b.name));
  }

  Stream<List<PolygonModel>> filterPolygons() {
    final filter = filterType == FilterType.created_by_me;
    final stream = filter
        ? _stream.map((event) => event.where((element) => element.createdBy?.id == userData?.id).toList())
        : _stream;
    _hasPolygons(stream);
    return stream;
  }

  Future<void> _hasPolygons(Stream<List<PolygonModel>> stream) async {
    // final _isEmpty = await stream.isEmpty;
    // print(await stream.length);
    // setState(() {
    //   hasPolygon = !_isEmpty;
    // });
  }

  Future<void> _warningDialog(BuildContext context) async {
    DialogService.showDialog(
      child: DialogLayout(
        child: Padding(
          padding: kPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // alert text
              Image.asset(
                'assets/icons/warning_icon.png',
                height: 20.height,
              ),
              Gap(10.h),
              Text(
                'Are you sure you want to send this WARNING alert?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Row(
                children: [
                  Gap(20.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        final result = await context.read<Api>().sendEmergencyNotification(
                              ids: selectedZones.toList(),
                            );
                        result.when(
                          success: (data) {
                            DialogService.showDialog(
                              child: DialogLayout(
                                child: Padding(
                                  padding: kPadding,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: data.isEmpty
                                        ? [
                                            Gap(20.h),
                                            Text(
                                              'No one is on the property to notify.',
                                              textAlign: TextAlign.center,
                                              style: context.textTheme.headline6?.copyWith(
                                                fontWeight: FontWeight.bold,

                                                // color: context.theme.primaryColor,
                                              ),
                                            ),
                                            Gap(20.h),
                                            MyElevatedButton(
                                              text: 'Go back',
                                              onPressed: () async => Get.back(),
                                            ),
                                          ]
                                        : [
                                            Gap(10.h),
                                            Text(
                                              'Notification sent to ${data.length} users',
                                              style: context.textTheme.headline6?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: context.theme.primaryColor,
                                              ),
                                            ),
                                            Gap(20.h),
                                            Expanded(
                                              child: ListView.separated(
                                                separatorBuilder: (context, index) => Divider(height: 1),
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Text(data[index].fullName),
                                                    subtitle: Text(data[index].role ?? ''),
                                                    dense: true,
                                                  );
                                                },
                                                itemCount: data.length,
                                              ),
                                            ),
                                            Gap(10.h),
                                            MyElevatedButton(
                                              text: 'Go back',
                                              onPressed: () async => Get.back(),
                                            ),
                                          ],
                                  ),
                                ),
                              ),
                            );
                            // DialogService.success(
                            //   // 'Alert sent successfully',
                            //   onCancel: Get.back,
                            // );
                          },
                          failure: (error) {
                            DialogService.error('Failed to send Alert');
                          },
                        );
                        // await DialogService.showDialog(child: const ComingSoonDialog());
                      },
                      child: const Text('Yes'),
                    ),
                  ),
                  Gap(10.w),

                  // no button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async => Get.back(),
                      child: const Text('No'),
                    ),
                  ),
                  Gap(20.w),

                  // Gap(10.w),
                ],
              ),
            ],
          ),
        ),
      ),
      // child: ErrorDialog(
      //   message: 'Are you sure you want to send this WARNING alert?',
      //   onTap: Get.back,
      // ),
    );
  }
}
