import 'package:api_repo/api_repo.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../helpers/callback_debouncer.dart';
import '../../../../../models/enum/filter_type.dart';
import '../../../models/polygon_model.dart';

abstract class GeofenceController extends BaseModel {
  FilterType filterType = FilterType.created_by_me;
  User? user;
  final searchController = TextEditingController();
  final _cd = CallbackDebouncer(200.milliseconds);

  /// Check if there are any polygons
  bool _hasPolygons = true;
  bool get hasPolygon => _hasPolygons;

  GeofenceController(super.context) {
    user = apiService.getUser();
    _checkPolygons(polygonStream);
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
        ? mapsRepo.polygonStream.map((event) => event.where(_search).toList())
        : mapsRepo.polygonStream.map(
            (event) => event.where(_createdByMe).where(_search).toList(),
          );
  }

  bool get isAdmin => api.getUser()?.role == 'Admin';
  bool _createdByMe(element) => element.createdBy?.id == user?.id;
  bool _search(element) => element.name.toLowerCase().contains(searchController.text.toLowerCase());

  void _checkPolygons(Stream<List<PolygonModel>> stream) {
    stream.listen((event) {
      _hasPolygons = event.isNotEmpty;
      notifyListeners();
    });
  }
}
