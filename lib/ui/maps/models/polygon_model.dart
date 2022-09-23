// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:api_repo/api_repo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolygonModel {
  final String? id;
  final Color color;
  final String name;
  final List<LatLng> points;
  final UserData? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PolygonModel({
    this.id,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      // 'createdAt': createdBy.toJson(),
    };
  }

  Map<String, dynamic> toApiJson() {
    return <String, dynamic>{
      'color': colorToHex(color),
      'points': points.map((x) => _latLngToJson(x)).toList(),
      'name': name,
      // 'createdAt': createdBy.toJson(),
    };
  }

  List<double> _latLngToJson(LatLng latLng) {
    return [latLng.longitude, latLng.latitude];
  }

  static LatLng _latLngFromJson(List<dynamic> latLng) {
    return LatLng(latLng.last, latLng.first);
  }

  factory PolygonModel.fromJson(Map<String, dynamic> json) {
    final points = json['points']['coordinates'][0];
    return PolygonModel(
      createdBy: UserData.fromJson(json['createdBy']),
      id: json['id'].toString(),
      color: _colorFromHex(json['color']),
      points: List<LatLng>.from((points as List<dynamic>).map((x) => _latLngFromJson((x))).toList()),
      name: json['name'],
      updatedAt: parseDateTime(json['updatedAt']),
      createdAt: parseDateTime(json['createdAt']),
    );
  }

  static DateTime? parseDateTime(String? date) => date == null ? null : DateTime.tryParse(date)?.toLocal();

  // color to hex
  String colorToHex(Color color) => color.value.toRadixString(16).padLeft(6, '0');

  static Color _colorFromHex(String hex) => Color(int.parse(hex, radix: 16));

  // color from hex
  Color colorFromHex(String hex) => Color(int.parse(hex, radix: 16));

  PolygonModel copyWith({
    String? id,
    Color? color,
    String? name,
    List<LatLng>? points,
    UserData? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PolygonModel(
      id: id ?? this.id,
      color: color ?? this.color,
      name: name ?? this.name,
      points: points ?? this.points,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
