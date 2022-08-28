import 'dart:ui';

import 'package:api_repo/api_repo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonModel {
  final String? id;
  final Color color;
  final String name;
  final List<LatLng> points;
  final UserData? createdBy;

  PolygonModel({
    this.id,
    this.createdBy,
    required this.name,
    required this.color,
    required this.points,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'color': colorToHex(color),
      'points': points.map((x) => _latLngToJson(x)).toList(),
      'name': name,
      // 'createdAt': createdBy.toJson(),
    };
  }

  Map<String, dynamic> _latLngToJson(LatLng latLng) {
    return <String, dynamic>{
      'latitude': latLng.latitude,
      'longitude': latLng.longitude,
    };
  }

  static LatLng _latLngFromJson(Map<String, dynamic> latLng) {
    return LatLng(double.parse(latLng['latitude']), double.parse(latLng['longitude']));
  }

  factory PolygonModel.fromJson(Map<String, dynamic> json) {
    return PolygonModel(
      createdBy: UserData.fromJson(json['createdBy']),
      id: json['id'].toString(),
      color: colorFromHex(json['color']),
      points: List<LatLng>.from(
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
