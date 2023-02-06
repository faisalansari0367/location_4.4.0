// import 'package:bioplus/ui/sos/provider/provider.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/services/notifications/intent_service.dart';
import 'package:bioplus/ui/maps/view/maps_page.dart';
import 'package:bioplus/ui/sos/sos.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// {@template sos_body}
/// Body of the SosPage.
///
/// Add what it does
/// {@endtemplate}
class SosBody extends StatelessWidget {
  /// {@macro sos_body}
  const SosBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SosNotifier>(
      builder: (context, state, child) {
        if (state.baseState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: state.sosNotifications.length,
          itemBuilder: (context, index) {
            final sos = state.sosNotifications[index];
            return ListTile(
              title: Text(sos.createdBy?.fullName ?? ''),
              subtitle: Text(
                MyDecoration.formatDateWithTime(
                  sos.sosDate ?? sos.createdAt,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  try {
                    IntentService.openMap(sos.locationUrl);
                  } catch (e) {
                    final latLng = sos.locationUrl.split('=').last;
                    final lat = double.parse(latLng.split(',').first);
                    final lng = double.parse(latLng.split(',').last);
                    Get.to(() => MapsPage(center: LatLng(lat, lng)));
                  }
                },
                icon: const Icon(Icons.location_pin),
              ),
            );
          },
        );
      },
    );
  }
}
