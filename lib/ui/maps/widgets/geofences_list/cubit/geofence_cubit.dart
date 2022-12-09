import 'package:bioplus/ui/maps/widgets/geofences_list/cubit/geofence_controller.dart';

class GeofenceCubit extends GeofenceController {
  GeofenceCubit(super.context);
  // final searchController = TextEditingController();

  // User? user;

  // GeofenceCubit(super.context) {
  //   user = apiService.getUser();
  // }

  // FilterType filterType = FilterType.created_by_me;

  // void onFilterTypeChange(FilterType filterType) {
  //   this.filterType = filterType;
  //   notifyListeners();
  // }

  // final _cd = CallbackDebouncer(200.milliseconds);
  // void onSearch(String value) {
  //   _cd.call(() {
  //     notifyListeners();
  //   });
  // }

  // bool get isAdmin => api.getUser()?.role == 'Admin';

  // Stream<List<PolygonModel>> get polygonStream {
  //   return filterType.isAll
  //       ? mapsRepo.polygonStream.map((event) => event.where(_search).toList())
  //       : mapsRepo.polygonStream.map(
  //           (event) => event.where(_createdByMe).where(_search).toList(),
  //         );
  // }

  // bool _createdByMe(element) => element.createdBy?.id == user?.id;
  // bool _search(element) => element.name.toLowerCase().contains(searchController.text.toLowerCase());
}
