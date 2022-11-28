import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/emergency_warning_page/provider/provider.dart';
import 'package:background_location/ui/maps/location_service/background_location_service.dart';
import 'package:background_location/ui/maps/location_service/maps_repo_local.dart';
import 'package:background_location/ui/maps/location_service/polygons_service.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:flutter/material.dart';
import 'package:local_notification/local_notification.dart';

import '../../../services/notifications/push_notifications.dart';
import '../cubit/maps_cubit.dart';
import 'maps_view.dart';

class MapsPage extends StatelessWidget {
  // to show selected polygon
  final PolygonModel? polygonId;
  final bool fromDrawer;
  const MapsPage({Key? key, this.fromDrawer = false, this.polygonId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(

      create: (context) => MapsCubit(
        context,
        context.read<NotificationService>(),
        // context.read<MapsRepo>(),
        context.read<PolygonsService>(),
        context.read<PushNotificationService>(),
        context.read<Api>(),
        context.read<MapsRepoLocal>(),
        geofenceService: context.read<GeofenceService>(),
      ),
      child: MapsView(fromDrawer: fromDrawer),
    );
  }
}
