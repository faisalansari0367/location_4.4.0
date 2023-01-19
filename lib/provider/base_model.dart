import 'package:api_repo/api_repo.dart';
import 'package:bioplus/services/notifications/connectivity/connectivity_service.dart';
import 'package:bioplus/services/notifications/push_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseModel extends ChangeNotifier {
  late Api api;
  late LocalApi localApi;

  late Api apiService;
  bool mounted = true;
  // late NotificationService service;
  late GeofencesRepo _geofenceRepo;
  late GeofencesRepo _geofenceRepoLocal;
  // late GeofencesRepo geofenceRepo;
  late PushNotificationService pushNotificationService;

  GeofencesRepo get geofenceRepo => MyConnectivity.isConnected ? _geofenceRepo : _geofenceRepoLocal;

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
    _geofenceRepo = context.read<Api>();
    _geofenceRepoLocal = context.read<LocalApi>();
    pushNotificationService = context.read<PushNotificationService>();

    apiService = api;
    // geofenceRepo = _geofenceRepo;
    MyConnectivity().connectionStream.listen((event) {
      apiService = event ? api : localApi;
      // geofenceRepo = event ? _geofenceRepoLocal : _geofenceRepoLocal;
      _emit(baseState.copyWith(isConnected: event));
    });
  }

  BaseModelState baseState = BaseModelState();

  void setLoading(bool value) {
    _emit(baseState.copyWith(isLoading: value));
    notifyListeners();
  }

  void _emit(BaseModelState state) {
    baseState = state;
    if (mounted) notifyListeners();
  }

  @override
  void notifyListeners() {
    if (mounted) super.notifyListeners();
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
