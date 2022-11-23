enum FilterType { created_by_me, all }

extension FilterTypeExt on FilterType {
  bool get isCreatedByMe => this == FilterType.created_by_me;
  bool get isAll => this == FilterType.all;
}