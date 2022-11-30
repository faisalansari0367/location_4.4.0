import 'dart:async';

import 'package:api_repo/api_repo.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:background_location/widgets/dialogs/mail_sent_dialog.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

import '../../maps/location_service/geolocator_service.dart';

part 'sos_warning_state.dart';

class SosWarningCubit extends Cubit<SosWarningState> {
  final Api api;
  SosWarningCubit(this.api) : super(const SosWarningInitial());

  /// A description for yourCustomFunction
  FutureOr<void> sendSos() async {
    final LatLng latLng = await GeolocatorService.getCurrentLatLng();
    final result = await api.sendSos(latLng.latitude, latLng.longitude);
    result.when(success: success, failure: failure);
    // Get.back();
  }

  Object? failure(NetworkExceptions error) {
    DialogService.failure(error: error);
    return null;
  }

  Object? success(data) {
    Get.back();
    DialogService.showDialog(child: MailSentDialog(message: 'Emergency Mail Sent', onContinue: Get.back));
    return null;
  }
}
