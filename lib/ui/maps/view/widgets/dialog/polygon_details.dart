import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../location_service/map_toolkit_utils.dart';

class PolygonDetails extends StatelessWidget {
  final PolygonModel polygonModel;
  final bool canEdit;
  final VoidCallback onTap;
  const PolygonDetails({Key? key, required this.polygonModel, this.canEdit = false, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 5.width,
        right: 5.width,
        bottom: context.mediaQueryViewPadding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Field Details',
            style: context.textTheme.headline6?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
            ),
          ),
          Gap(2.height),
          Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Field Name',
                style: context.textTheme.subtitle2?.copyWith(
                  // fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                polygonModel.name,
                style: context.textTheme.subtitle2?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Field Area',
                style: context.textTheme.subtitle2?.copyWith(
                  // fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                '${getPolygonArea(polygonModel.points).toStringAsFixed(2)} m2',
                style: context.textTheme.subtitle2?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          Divider(),
          if (canEdit)
            InkWell(
              onTap: onTap,
              // onTap: () {
              //   final cubit = context.read<MapsCubit>();
              //   cubit.setIsAddingGeofence();
              //   context.read<PolygonsService>().addPolygon(data.points);
              //   Get.back();
              // },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Field Area',
                    style: context.textTheme.subtitle2?.copyWith(
                      fontSize: 16.sp,
                    ),
                  ),
                  Icon(Icons.edit),
                ],
              ),
            ),
        ],
      ),
    );
  }

  num getPolygonArea(List<LatLng> polypoints) {
    final area = MapsToolkitService.calculatePolygonArea(polypoints);
    return area;
  }
}
