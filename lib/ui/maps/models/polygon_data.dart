// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:background_location/ui/maps/view/widgets/select_color.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'enums/filed_assets.dart';

class PolygonData extends Equatable {
  final List<LatLng> points;
  final FieldAssets type;
  PolygonData({
    required this.points,
    required this.type,
  });

  @override
  List<Object?> get props => [points, type];
}
