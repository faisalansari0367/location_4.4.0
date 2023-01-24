class SelectRoleModel {
  final String role;
  bool isSelected;
  final bool isPaidRole;
  final bool isSubscribed;
  SelectRoleModel({
    required this.isPaidRole,
    required this.role,
    this.isSelected = false,
    this.isSubscribed = false,
  });

  void setSelect(bool value) {
    isSelected = value;
  }
}
