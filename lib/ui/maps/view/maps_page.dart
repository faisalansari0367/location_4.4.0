import 'dart:convert';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/services/notifications/push_notifications.dart';
import 'package:bioplus/ui/emergency_warning_page/provider/provider.dart';
import 'package:bioplus/ui/maps/cubit/maps_cubit.dart';
import 'package:bioplus/ui/maps/location_service/geofence_service.dart';
import 'package:bioplus/ui/maps/location_service/polygons_service.dart';
import 'package:bioplus/ui/maps/view/maps_view.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatelessWidget {
  // to show selected polygon
  final PolygonModel? polygonId;
  final LatLng? center;
  final bool fromDrawer;
  const MapsPage({super.key, this.fromDrawer = false, this.polygonId, this.center});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MapsCubit(
        context,
        
        // context.read<NotificationService>(),
        // context.read<MapsRepo>(),
        context.read<PolygonsService>(),
        context.read<PushNotificationService>(),
        context.read<Api>(),
        latLng: center,
        // context.read<MapsRepoLocal>(),
        geofenceService: context.read<GeofenceService>(),
      ),
      child: MapsView(fromDrawer: fromDrawer),
    );
  }
}
