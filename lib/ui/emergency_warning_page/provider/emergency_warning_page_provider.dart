import 'dart:core';

import 'package:bioplus/ui/maps/widgets/geofences_list/cubit/geofence_controller.dart';

import '../../maps/location_service/maps_repo.dart';

class EmergencyWarningPageNotifier extends GeofenceController {
  final selectedZones = Set<int>();
  // FilterType filterType = FilterType.created_by_me;
  // bool hasPolygon = false;
  // UserData? userData;
  final MapsRepo mapsRepo;

  EmergencyWarningPageNotifier(super.context, {required this.mapsRepo}) {
    _getPolygon();
    // userData = api.getUserData();
    // _hasPolygons(polygonStream);
  }

  Future<void> _getPolygon() async {
    if (!mapsRepo.hasPolygons) {
      mapsRepo.getAllPolygon();
    }
  }

  // setFilter() {
  //   filterType = filterType == FilterType.created_by_me ? FilterType.all : FilterType.created_by_me;
  //   notifyListeners();
  // }

  // Stream<List<PolygonModel>> get stream => filterPolygons();

  // List<PolygonModel> sort(List<PolygonModel>? list) {
  //   if (list == null) return [];
  //   if (list.isEmpty) return [];
  //   return list..sort((a, b) => a.name.compareTo(b.name));
  // }

  void addOrRemovePolygons(String fenceId) {
    final id = int.parse(fenceId);
    final ids = selectedZones.where((element) => element == id);
    if (ids.isEmpty) {
      selectedZones.add(id);
    } else {
      selectedZones.remove(id);
    }
    notifyListeners();
  }

  bool isZoneSelected(String fenceId) => selectedZones.contains(int.parse(fenceId));

  // Stream<List<PolygonModel>> filterPolygons() {
  //   final _stream = mapsRepo.polygonStream;
  //   final filter = filterType == FilterType.created_by_me;
  //   final stream = filter
  //       ? _stream.map((event) => event.where((element) => element.createdBy?.id == userData?.id).toList()
  //         ..sort((a, b) => a.name.compareTo(b.name)))
  //       : _stream;
  //   return stream;
  // }

  // void _hasPolygons(Stream<List<PolygonModel>> stream) {
  //   stream.listen((event) {
  //     hasPolygon = event.isNotEmpty;
  //     notifyListeners();
  //   });
  // }
}
