import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/maps/widgets/geofences_list/cubit/geofence_cubit.dart';
import 'package:bioplus/ui/maps/widgets/geofences_list/geofence_card.dart';
import 'package:bioplus/widgets/animations/animations.dart';
import 'package:bioplus/widgets/empty_screen.dart';
import 'package:bioplus/widgets/filter_widget/filter_widget.dart';
import 'package:bioplus/widgets/listview/my_listview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class GeofencesList extends StatefulWidget {
  final ScrollController? controller;
  final ValueChanged<PolygonModel> onSelected;
  final Widget? emptyScreen;
  final bool Function(PolygonModel model)? isSelected;
  final bool showCloseButton;
  const GeofencesList({
    super.key,
    this.controller,
    required this.onSelected,
    this.isSelected,
    this.showCloseButton = true,
    this.emptyScreen,
  });

  @override
  State<GeofencesList> createState() => _GeofencesListState();
}

class _GeofencesListState extends State<GeofencesList> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GeofenceCubit(context),
      child: Consumer<GeofenceCubit>(
        builder: (context, cubit, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: kPadding.copyWith(bottom: 0),
              child: Column(
                children: [
                  _selectLocationHeader(context),
                  // if (cubit.isAdmin)
                  FilterWidget(
                    filters: cubit.filters,
                    selectedFilter: cubit.filterType,
                    onFilterChanged: cubit.onFilterTypeChange,
                  ),
                  Gap(10.h),
                  CupertinoSearchTextField(
                    controller: cubit.searchController,
                    onChanged: cubit.onSearch,
                  ),
                  Gap(10.h),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<PolygonModel>>(
                stream: cubit.polygonStream,
                builder: (context, snapshot) {
                  return Scrollbar(
                    controller: widget.controller,
                    child: MyListview(
                      data: snapshot.data ?? [],
                      emptyWidget: widget.emptyScreen ?? _emptyWidget(),
                      padding: EdgeInsets.symmetric(
                        horizontal: kPadding.left,
                        vertical: 5.h,
                      ),
                      controller: widget.controller,
                      itemBuilder: (context, index) {
                        final fence = snapshot.data![index];
                        return GeofenceCard(
                          isSelected: widget.isSelected?.call(fence) ?? false,
                          onTap: () => widget.onSelected.call(fence),
                          item: fence,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            // Gap(10.h),
          ],
        ),
      ),
    );
  }

  Center _emptyWidget() {
    return const Center(
      child: EmptyScreen(
        message: 'You have not created any geofences',
        messsageOnTop: true,
      ),
    );
  }

  Row _selectLocationHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          'Select A Location',
          style: context.textTheme.headline6?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (widget.showCloseButton)
          AnimatedButton(
            scale: 0.8,
            onTap: Get.back,
            child: Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.clear),
            ),
          ),
      ],
    );
  }
}
