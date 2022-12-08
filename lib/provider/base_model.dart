import 'package:api_repo/api_repo.dart';
import 'package:bioplus/services/notifications/connectivity/connectivity_service.dart';
import 'package:bioplus/services/notifications/push_notifications.dart';
import 'package:bioplus/ui/maps/location_service/maps_repo.dart';
import 'package:bioplus/ui/maps/location_service/maps_repo_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_notification/local_notification.dart';

abstract class BaseModel extends ChangeNotifier {
  late Api api;
  late LocalApi localApi;

  late Api apiService;
  bool mounted = true;
  late NotificationService service;
  late MapsRepo mapsRepo;
  late MapsRepoLocal _mapsRepoLocal;
  late PushNotificationService pushNotificationService;


  //
  //  context.read<NotificationService>(),
  //       context.read<MapsRepo>(),
  //       context.read<PolygonsService>(),
  //       context.read<PushNotificationService>(),
  //       context.read<Api>(),
  //       context.read<MapsRepoLocal>(),
  //       geofenceService: context.read<GeofenceService>(),

  // bool _isLoading = true;

  // bool get isLoading => _isLoading;

  // void setLoading(bool value) {
  //   _isLoading = value;
  //   notifyListeners();
  // }


  BaseModel(BuildContext context) {
    api = context.read<Api>();
    localApi = context.read<LocalApi>();
    mapsRepo = context.read<MapsRepo>();
    _mapsRepoLocal = context.read<MapsRepoLocal>();
    pushNotificationService = context.read<PushNotificationService>();

    apiService = api;
    MyConnectivity().connectionStream.listen((event) {
      apiService = event ? api : localApi;
      mapsRepo = event ? mapsRepo : _mapsRepoLocal;
      _emit(baseState.copyWith(isConnected: event));
    });
  }

  BaseModelState baseState = BaseModelState();

  void setLoading(bool value) {
    _emit(baseState.copyWith(isLoading: value));
    notifyListeners();
  }

  void _emit(BaseModelState state) {
    this.baseState = state;
    if (mounted) notifyListeners();
  }

  @override
  void dispose() {
    mounted = false;
    super.dispose();
  }
}

// base model state
class BaseModelState {
  final bool isLoading;
  final bool isConnected;

  BaseModelState({
    this.isLoading = false,
    this.isConnected = true,
  });

  BaseModelState copyWith({
    bool? isLoading,
    bool? isConnected,
  }) {
    return BaseModelState(
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
