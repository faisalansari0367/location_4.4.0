import 'dart:async';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../helpers/callback_debouncer.dart';
import '../../../../../models/enum/filter_type.dart';

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

  Stream<List<PolygonModel>> get polygonStream {
    return filterType.isAll
        ? geofenceRepo.polygonStream.map((event) => event.where(_search).toList())
        : geofenceRepo.polygonStream.map(
            (event) => event.where(_createdByMe).where(_search).toList(),
          );
  }

  bool get isAdmin => api.getUser()?.role == 'Admin';
  bool _createdByMe(element) => element.createdBy?.id == user?.id;
  bool _search(element) => element.name.toLowerCase().contains(searchController.text.toLowerCase());

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
