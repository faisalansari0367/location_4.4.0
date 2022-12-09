import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bioplus/ui/emergency_warning_page/provider/provider.dart';
import 'package:bioplus/ui/maps/widgets/geofences_list/geofences_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/index.dart';
import '../../../widgets/dialogs/dialog_layout.dart';
import '../../../widgets/dialogs/dialog_service.dart';
import '../../../widgets/empty_screen.dart';
import '../../../widgets/my_appbar.dart';
import '../../maps/view/maps_page.dart';

/// {@template emergency_warning_page_body}
/// Body of the EmergencyWarningPagePage.
///
/// Add what it does
/// {@endtemplate}
class EmergencyWarningPageBody extends StatelessWidget {
  /// {@macro emergency_warning_page_body}
  const EmergencyWarningPageBody({super.key});

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
      bottomNavigationBar: Selector<EmergencyWarningPageNotifier, bool>(
        selector: (p0, p1) => p1.hasPolygon,
        builder: (context, value, child) => value ? _bottomNavbar(context) : const SizedBox(),
      ),
      // bottomNavigationBar: _bottomNavbar(context),
      body: Consumer<EmergencyWarningPageNotifier>(
        builder: (context, state, child) {
          return state.hasPolygon ? _buildBody(context) : _noGeofences();
          // return _buildBody(context);
        },
      ),
    );
  }

  Widget _noGeofences() {
    return SizedBox(
      child: Center(
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
    );
  }

  Column _buildBody(BuildContext context) {
    final provider = context.read<EmergencyWarningPageNotifier>();
    return Column(
      children: [
        Center(
          child: Image.asset(
            'assets/icons/warning_icon.png',
            height: 100,
          ),
        ),
        Expanded(
          child: GeofencesList(
            emptyScreen: _noGeofences(),
            showCloseButton: false,
            onSelected: (value) => provider.addOrRemovePolygons(value.id!),
            isSelected: (model) => provider.isZoneSelected(model.id!),
          ),
        ),
        // Text(
        //   'Select A Location',
        //   style: context.textTheme.headline6?.copyWith(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // Gap(20.h),
        // if (provider.userData?.role == 'Admin') ...[
        //   Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 20.w),
        //     child: Row(
        //       children: [
        //         _buildFilters(context),
        //         Gap(10.h),
        //       ],
        //     ),
        //   ),
        // ],
        // Expanded(
        //   child: StreamBuilder<List<PolygonModel>>(
        //     stream: provider.stream,
        //     builder: (context, snapshot) {
        //       return Scrollbar(
        //         child: ListView.separated(
        //           separatorBuilder: (context, index) => Gap(10.h),
        //           padding: kPadding,
        //           itemCount: (snapshot.data ?? []).length,
        //           itemBuilder: (context, index) {
        //             final fence = snapshot.data![index];
        //             return GeofenceCard(
        //               onTap: () => provider.addOrRemovePolygons(fence.id!),
        //               isSelected: provider.isZoneSelected(fence.id!),
        //               item: fence,
        //             );
        //           },
        //         ),
        //       );
        //     },
        //   ),
        // ),
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

  // Row _buildFilters(BuildContext context) {
  //   final provider = context.read<EmergencyWarningPageNotifier>();

  //   return Row(
  //     children: [
  //       Text(
  //         'Filter by',
  //         style: TextStyle(
  //           fontSize: 15.h,
  //           fontWeight: FontWeight.w600,
  //           color: Colors.grey,
  //         ),
  //       ),
  //       ...FilterType.values
  //           .map(
  //             (e) => Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 5.w),
  //               child: InputChip(
  //                 selected: provider.filterType == e,
  //                 backgroundColor: Colors.grey.shade200,
  //                 selectedColor: context.theme.primaryColor.withOpacity(1),
  //                 // elevation: 5,
  //                 onPressed: () => provider.onFilterTypeChange(e),
  //                 checkmarkColor: provider.filterType == e ? Colors.white : Colors.grey,

  //                 label: Text(
  //                   e.name.replaceAll('_', ' ').capitalize!,
  //                   style: TextStyle(
  //                     fontSize: 15.h,
  //                     color: provider.filterType == e ? Colors.white : Colors.grey.shade700,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           )
  //           .toList()
  //     ],
  //   );
  // }

  Future<void> _warningDialog(BuildContext context) async {
    final provider = context.read<EmergencyWarningPageNotifier>();

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
                              ids: provider.selectedZones.toList(),
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
                          },
                          failure: (error) {
                            // DialogService.error(
                            //   NetworkExceptions.getErrorMessage(error).capitalizeFirst!,
                            // );
                            DialogService.showDialog(
                              child: DialogLayout(
                                child: Padding(
                                  padding: kPadding,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 4 / 3,
                                        child: Lottie.asset(
                                          'assets/animations/orange_alert.json',
                                        ),
                                      ),
                                      Gap(20.h),
                                      Text(
                                        NetworkExceptions.getErrorMessage(error).capitalizeFirst!,
                                        textAlign: TextAlign.center,
                                        style: context.textTheme.headline6?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28.sp,
                                          // color: context.theme.primaryColor,
                                        ),
                                      ),
                                      Gap(20.h),
                                      MyElevatedButton(
                                        text: Strings.continue_,
                                        onPressed: () async => Get.back(),
                                        width: 25.width,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            // DialogService.failure(error: error);
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
    );
  }
}
