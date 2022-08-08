// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'maps_cubit.dart';

class MapsState extends Equatable {
  final bool insideFence;
  final LatLng currentLocation;
  final MapType mapType;
  final List<LatLng> latLngs;
  final Set<List<LatLng>> polygons;
  final Set<Circle> circles;
  final bool addingGeofence;

  const MapsState({
    required this.currentLocation,
    this.addingGeofence = false,
    this.circles = const <Circle>{},
    this.polygons = const <List<LatLng>>{},
    this.latLngs = const <LatLng>[],
    this.mapType = MapType.hybrid,
    this.insideFence = false,
  });

  MapsState copyWith({
    bool? insideFence,
    LatLng? currentLocation,
    MapType? mapType,
    List<LatLng>? latLngs,
    Set<List<LatLng>>? polygons,
    Set<Circle>? circles,
    bool? addingGeofence,
  }) {
    return MapsState(
      insideFence: insideFence ?? this.insideFence,
      currentLocation: currentLocation ?? this.currentLocation,
      mapType: mapType ?? this.mapType,
      latLngs: latLngs ?? this.latLngs,
      polygons: polygons ?? this.polygons,
      circles: circles ?? this.circles,
      addingGeofence: addingGeofence ?? this.addingGeofence,
    );
  }

  
  @override
  List<Object> get props => [
        insideFence,
        currentLocation,
        mapType,
        latLngs,
        polygons,
        circles,
        addingGeofence,
      ];
}
