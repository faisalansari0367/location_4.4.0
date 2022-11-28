import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/dialogs/delete_dialog.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../location_service/map_toolkit_utils.dart';
import '../../../location_service/maps_repo.dart';

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
        bottom: context.mediaQueryViewPadding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5.width),
            child: Text(
              'Field Details',
              style: context.textTheme.headline6?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20.sp,
              ),
            ),
          ),
          Gap(2.height),
          // ListTile(),
          AutoSpacing(
            removeLast: true,
            spacing: Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.withOpacity(.3),
            ),
            children: [
              _customTile(
                'Field Name',
                value: polygonModel.name,
              ),
              _customTile(
                'Created By',
                value: polygonModel.createdBy?.fullName,
              ),
              if (polygonModel.companyOwner != null)
                _customTile(
                  'Company Owner Name',
                  value: polygonModel.companyOwner ?? '',
                ),
              _customTile(
                'Field Area',
                value: '${getPolygonArea(polygonModel.points).toStringAsFixed(2)} m2',
              ),
              if (canEdit)
                _customTile(
                  'Edit Field Area',
                  icon: (Icons.edit),
                  onTap: onTap,
                ),
              if (canEdit)
                _customTile(
                  'Delete Geofence',
                  showDivider: false,
                  icon: (Icons.delete),
                  onTap: () {
                    DialogService.showDialog(
                      child: DeleteDialog(
                        onConfirm: () async {
                          Get.back();
                          await context.read<MapsRepo>().deletePolygon(polygonModel);
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _customTile(String title, {String? value, IconData? icon, VoidCallback? onTap, bool showDivider = true}) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        enabled: true,
        onTap: onTap,
        trailing: icon != null
            ? Icon(icon)
            : Text(
                value!,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
        contentPadding: EdgeInsets.symmetric(horizontal: 5.width),
        dense: true,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  num getPolygonArea(List<LatLng> polypoints) {
    final area = MapsToolkitService.calculatePolygonArea(polypoints);
    return area;
  }
}
