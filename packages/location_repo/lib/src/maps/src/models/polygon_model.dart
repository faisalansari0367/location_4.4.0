// ignore_for_file: public_member_api_docs, sort_constructors_first

// import 'package:google_maps/google_maps.dart' show LatLng;
// import 'package:json_annotation/json_annotation.dart';
import 'dart:ui';

import 'latlng.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
// import 'package:location_repo/location_repo.dart';
// import 'package:location_repo/location_repo.dart';

// part 'polygon_model.g.dart';

// @JsonSerializable()
class PolygonModel {
  final String? id;
  final Color color;
  final String name;
  final List<PolygonLatLng> points;

  PolygonModel({
    required this.name,
    this.id,
    required this.color,
    required this.points,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'color': colorToHex(color),
      'points': points.map((x) => _latLngToJson(x)).toList(),
      'name': name,
    };
  }

  Map<String, dynamic> _latLngToJson(PolygonLatLng latLng) {
    return <String, dynamic>{
      'latitude': latLng.latitude,
      'longitude': latLng.longitude,
    };
  }

  static PolygonLatLng _latLngFromJson(Map<String, dynamic> latLng) {
    return PolygonLatLng(latLng['latitude'], latLng['longitude']);
  }

  factory PolygonModel.fromJson(Map<String, dynamic> json) {
    return PolygonModel(
      id: json['id'],
      color: colorFromHex(json['color']),
      points: List<PolygonLatLng>.from(
          (json['points'] as List<dynamic>).map((x) => _latLngFromJson(Map<String, dynamic>.from(x))).toList()),
      name: json['name'],
    );
  }

  // color to hex
  static String colorToHex(Color color) {
    return color.value.toRadixString(16).padLeft(6, '0');
  }

  // color from hex
  static Color colorFromHex(String hex) {
    return Color(int.parse(hex, radix: 16));
  }
}
