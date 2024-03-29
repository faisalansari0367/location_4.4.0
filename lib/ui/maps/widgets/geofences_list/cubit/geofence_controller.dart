import 'dart:async';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/helpers/callback_debouncer.dart';
import 'package:bioplus/models/enum/filter_type.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

abstract class GeofenceController extends BaseModel {
  FilterType filterType = FilterType.created_by_me;
  User? user;
  final searchController = TextEditingController();
  final _cd = CallbackDebouncer(200.milliseconds);
  StreamSubscription<List<PolygonModel>>? _streamSubscription;

  /// Check if there are any polygons
  bool get hasPolygon => geofenceRepo.hasPolygons;

  GeofenceController(super.context) {
    user = apiService.getUser();
    // _checkPolygons(polygonStream);
  }

  void onFilterTypeChange(FilterType filterType) {
    this.filterType = filterType;
    notifyListeners();
  }

  void onSearch(String value) {
    _cd.call(() {
      notifyListeners();
    });
  }

  List<FilterType> get filters =>
      isAdmin ? FilterType.values : FilterType.values.where((element) => element != FilterType.all).toList();

  Stream<List<PolygonModel>> get polygonStream {
    // late Iterable<PolygonModel> = geofenceRepo.polygonStream.where((event) => event.toList());
    switch (filterType) {
      case FilterType.all:
        return geofenceRepo.polygonStream.map((event) => event.where(_search).toList());
      case FilterType.created_by_me:
        return geofenceRepo.polygonStream.map((event) => event.where(_createdByMe).where(_search).toList());
      case FilterType.delegated_geofences:
        return geofenceRepo.polygonStream.map((event) => event.where(isDelegatedGeofence).where(_search).toList());
      default:
        return geofenceRepo.polygonStream.map((event) => event.where(_createdByMe).where(_search).toList());
    }

    // return filterType.isAll
    //     ? geofenceRepo.polygonStream.map((event) => event.where(_search).toList())
    //     : geofenceRepo.polygonStream.map(
    //         (event) => event.where(_createdByMe).where(_search).toList(),
    //       );
  }

  bool isDelegatedGeofence(PolygonModel polygon) => user?.id == polygon.temporaryOwner?.id;

  bool get isAdmin => api.getUser()?.role == 'Admin';
  bool _createdByMe(PolygonModel element) => element.createdBy?.id == user?.id;
  bool _search(PolygonModel element) => element.name.toLowerCase().contains(searchController.text.toLowerCase());

  // void _checkPolygons(Stream<List<PolygonModel>> stream) {
  //   _streamSubscription = stream.listen((event) {
  //     // _hasPolygons = event.isNotEmpty;
  //     _hasPolygons = geofenceRepo.hasPolygons;
  //     notifyListeners();
  //   });
  // }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
