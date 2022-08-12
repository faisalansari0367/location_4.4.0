// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'maps_cubit.dart';
// part 'maps_state.g.dart';


// @JsonSerializable()
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
  final PolygonData? currentPolygon;
  final Color selectedColor;

  const MapsState({
    this.selectedColor = Colors.blue,
    this.currentPolygon, 
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
    PolygonData? currentPolygon,
    Color? selectedColor,
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
      currentPolygon: currentPolygon ?? this.currentPolygon,
      selectedColor: selectedColor ?? this.selectedColor,
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
        if (currentPolygon != null) currentPolygon!,
        selectedColor,
      ];


  // factory MapsState.fromJson(Map<String, dynamic> json) => _$MapsStateFromJson(json);

  // /// Connect the generated [_$MapsStateToJson] function to the `toJson` method.
  // Map<String, dynamic> toJson() => _$MapsStateToJson(this);
}


class ColorSerialiser implements JsonConverter<Color, int> {
  const ColorSerialiser();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color color) => color.value;
}
