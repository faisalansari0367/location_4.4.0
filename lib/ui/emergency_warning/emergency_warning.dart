import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/widgets/my_appbar.dart';
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

class EmergencyWarning extends StatefulWidget {
  const EmergencyWarning({Key? key}) : super(key: key);

  @override
  State<EmergencyWarning> createState() => _EmergencyWarningState();
}

class _EmergencyWarningState extends State<EmergencyWarning> {
  final selectedZones = Set<int>();

  @override
  Widget build(BuildContext context) {
    print(selectedZones);
    return Scaffold(
      appBar: MyAppBar(),
      bottomNavigationBar: GestureDetector(
        onTap: (() => _warningDialog(context)),
        child: Container(
          decoration: MyDecoration.decoration(
            color: Color.fromARGB(255, 255, 23, 23),
            // color: Colors.grey,
          ),
          height: 100.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Send Notification',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.sp,
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Text(
              'Emergency Warning',
              style: context.textTheme.headline6?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 32.sp,
              ),
            ),
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
            Expanded(
              child: StreamBuilder<List<PolygonModel>>(
                stream: context.read<MapsRepo>().polygonStream.map((event) =>
                    event.where((element) => element.createdBy?.id == context.read<Api>().getUserData()?.id).toList()),
                builder: (context, snapshot) {
                  return Scrollbar(
                    // controller: widget.controller,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Gap(10.h),
                      // controller: widget.controller,
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
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PolygonModel> sort(List<PolygonModel>? list) {
    if (list == null) return [];
    if (list.isEmpty) return [];
    return list..sort((a, b) => a.name.compareTo(b.name));
  }

  _warningDialog(BuildContext context) async {
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

              // yes no buttons
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Spacer(),
                  // yes button
                  Gap(20.w),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        final result = await context.read<Api>().sendEmergencyNotification();
                        result.when(
                          success: (data) {
                            DialogService.success(
                              'Alert sent successfully',
                              onCancel: Get.back,
                            );
                          },
                          failure: (error) {
                            DialogService.error('Failed to sent Alert');
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
