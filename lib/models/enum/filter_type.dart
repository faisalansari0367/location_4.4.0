enum FilterType { created_by_me, all, delegated_geofences }

extension FilterTypeExt on FilterType {
  bool get isCreatedByMe => this == FilterType.created_by_me;
  bool get isAll => this == FilterType.all;
  bool get isDelegatedGeofences => this == FilterType.delegated_geofences;
}
