import 'package:api_repo/api_repo.dart';
import 'package:background_location/helpers/callback_debouncer.dart';
import 'package:background_location/provider/base_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../models/enum/filter_type.dart';
import '../../../models/polygon_model.dart';

class GeofenceCubit extends BaseModel {
  final searchController = TextEditingController();

  User? user;

  GeofenceCubit(super.context) {
    user = apiService.getUser();
  }

  FilterType filterType = FilterType.created_by_me;

  void onFilterTypeChange(FilterType filterType) {
    this.filterType = filterType;

    notifyListeners();
  }

  

  final _cd = CallbackDebouncer(200.milliseconds);
  void onSearch(String value) {
    _cd.call(() {
      notifyListeners();
    });
    // notifyListeners();
  }

  bool get isAdmin => api.getUser()?.role == 'Admin';

  Stream<List<PolygonModel>> get polygonStream => filterType.isAll
      ? mapsRepo.polygonStream.map((event) => event.where(_search).toList())
      : mapsRepo.polygonStream.map(
          (event) => event.where((element) => element.createdBy?.id == user?.id).where(_search).toList(),
        );

  bool _search(element) => element.name.toLowerCase().contains(searchController.text.toLowerCase());
}
