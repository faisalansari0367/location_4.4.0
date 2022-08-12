// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:json_annotation/json_annotation.dart';

// import 'package:background_location/ui/maps/cubit/maps_cubit.dart';


// part 'polygon_data.g.dart';

// @JsonSerializable()
class PolygonData extends Equatable {
  // @JsonKey(fromJson: pointsFromJson, toJson: pointsTOJson)
  final List<LatLng> points;
  final String name;
  // @ColorSerialiser()
  final Color color;
  PolygonData({
    required this.name, 
    required this.points,
    required this.color,
  });

  @override
  List<Object?> get props => [points, color, name];

  // factory PolygonData.fromJson(Map<String, dynamic> json) => _$PolygonDataFromJson(json);

  /// Connect the generated [_$PolygonDataToJson] function to the `toJson` method.
  // Map<String, dynamic> toJson() => _$PolygonDataToJson(this);

  // static LatLng latlngFromJson(Map<String, dynamic> json) {
  //   return LatLng(json['latitude'], json['longitude']);
  // }

  // // latlng to json
  // static Map<String, dynamic> latlngToJson(LatLng latlng) {
  //   return {
  //     'latitude': latlng.latitude,
  //     'longitude': latlng.longitude,
  //   };
  // }

  // static List<Map<String, dynamic>> pointsFromJson(List<dynamic> json) {
  //   return json.map((e) => latlngToJson(e)).toList();
  // }

  // static List<LatLng> pointsTOJson(List<dynamic> json) {
  //   return json.map((e) => latlngFromJson(e)).toList();
  // }

  // static PolygonData fromJson(Map<String, dynamic> json) {
  //   return PolygonData(
  //     name: json['name'] as String,
  //     points: (json['points'] as List<dynamic>)
  //         .map((e) => PolygonData.latlngFromJson(e as Map<String, dynamic>))
  //         .toList(),
  //     color: Color(int.parse(json['color'] as String)),
  //   );
  // }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'points': points.map((x) => x.toMap()).toList(),
  //     'name': name,
  //     'color': color.value,
  //   };
  // }

  // factory PolygonData.fromMap(Map<String, dynamic> map) {
  //   return PolygonData(
  //     points: List<LatLng>.from((map['points'] as List<int>).map<LatLng>((x) => LatLng.fromMap(x as Map<String,dynamic>),),),
  //     name: map['name'] as String,
  //     color: Color(map['color'] as int),
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory PolygonData.fromJson(String source) => PolygonData.fromMap(json.decode(source) as Map<String, dynamic>);
}
