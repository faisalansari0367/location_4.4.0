// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'maps_cubit.dart';

class MapsState extends Equatable {
  final bool insideFence;
  final LatLng currentLocation;
  final MapType mapType;
  final List<LatLng> latLngs;
  final Set<PolygonData> polygons;
  final Set<Circle> circles;
  final bool addingGeofence;
  final FieldAssets fieldAsset;
  final double zoom;

  const MapsState({
    this.insideFence = false,
    required this.currentLocation,
    this.mapType = MapType.hybrid,
    this.latLngs = const <LatLng>[],
    this.polygons = const <PolygonData>{},
    this.circles = const <Circle>{},
    this.addingGeofence = false,
    this.fieldAsset = FieldAssets.paddyFields,
    this.zoom = 20.0,
  });

  MapsState copyWith({
    bool? insideFence,
    LatLng? currentLocation,
    MapType? mapType,
    List<LatLng>? latLngs,
    Set<PolygonData>? polygons,
    Set<Circle>? circles,
    bool? addingGeofence,
    FieldAssets? fieldAsset,
    double? zoom,
  }) {
    return MapsState(
      insideFence: insideFence ?? this.insideFence,
      currentLocation: currentLocation ?? this.currentLocation,
      mapType: mapType ?? this.mapType,
      latLngs: latLngs ?? this.latLngs,
      polygons: polygons ?? this.polygons,
      circles: circles ?? this.circles,
      addingGeofence: addingGeofence ?? this.addingGeofence,
      fieldAsset: fieldAsset ?? this.fieldAsset,
      zoom: zoom ?? this.zoom,
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
        fieldAsset,
        zoom,
      ];
}
