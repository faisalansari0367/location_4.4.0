import 'dart:async';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/ui/maps/location_service/geolocator_service.dart';
import 'package:bioplus/ui/user_profile/provider/user_profile_provider.dart';
import 'package:bioplus/ui/user_profile/widgets/edit_profile.dart';
import 'package:bioplus/widgets/dialogs/dialogs.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:provider/provider.dart';

part 'sos_warning_state.dart';

class SosWarningCubit extends Cubit<SosWarningState> {
  final Api api;
  SosWarningCubit(this.api) : super(const SosWarningInitial());

  /// A description for yourCustomFunction
  FutureOr<void> sendSos() async {
    final LatLng latLng = await GeolocatorService.getCurrentLatLng();

    final result = await api.sendSos(latLng.latitude, latLng.longitude);
    _sendSMS(latLng);
    result.when(success: success, failure: failure);
    // Get.back();
  }

  // Future<void> sendSms() {}

  Future<void> _sendSMS(LatLng latLng) async {
    final user = api.getUserData();
    final contact = user?.emergencyMobileContact;

    if (contact == null) {
      return;
    }
    try {
      final mapUrl =
          'https://maps.google.com/?q=${latLng.latitude},${latLng.longitude}';
      final msg =
          'EMERGENCY situation regarding ${user?.firstName} ${user?.lastName} at\n $mapUrl';
      final String result = await sendSMS(message: msg, recipients: [contact]);
      DialogService.success(result, onCancel: Get.back);
    } on PlatformException catch (error) {
      DialogService.error(error.message ?? 'Unable to send sms.');
    }
  }

  Future<void> failure(NetworkExceptions error) async {
    final message = NetworkExceptions.getErrorMessage(error);

    if (message.contains('You must add')) {
      await DialogService.showDialog(
        child: ErrorDialog(
          message:
              'You must add emergency contact details in your profile for this to work.',
          onTap: () {
            Get.back();
            Get.to(
              () => ChangeNotifierProvider(
                create: (context) => UserProfileNotifier(context),
                child: const EditProfile(),
              ),
            );
          },
        ),
      );
      // Get.back();
      return;
    }

    DialogService.failure(
      error: error,
    );
  }

  Object? success(dynamic data) {
    Get.back();
    DialogService.showDialog(
      child: MailSentDialog(
        message: 'Emergency Mail Sent',
        onContinue: Get.back,
      ),
    );
    return null;
  }
}
