class PolygonLatLng {
  final double latitude;
  final double longitude;

  PolygonLatLng(this.latitude, this.longitude);

  PolygonLatLng.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'] as double,
        longitude = json['longitude'] as double;

  Map<String, dynamic> toJson() => <String, dynamic>{'latitude': latitude, 'longitude': longitude};
}
