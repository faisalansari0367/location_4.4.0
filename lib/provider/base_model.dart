import 'package:api_repo/api_repo.dart';
import 'package:background_location/services/notifications/connectivity/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseModel extends ChangeNotifier {
  late Api api;
  late LocalApi localApi;
  late Api apiService;
  bool mounted = true;
  bool _isLoading = true;

  // bool get isLoading => _isLoading;

  // void setLoading(bool value) {
  //   _isLoading = value;
  //   notifyListeners();
  // }


  BaseModel(BuildContext context) {
    api = context.read<Api>();
    localApi = context.read<LocalApi>();
    apiService = api;
    MyConnectivity().connectionStream.listen((event) {
      apiService = event ? api : localApi;
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
