class SelectRoleModel {
  final String role;
  bool isSelected;
  final bool isPaidRole;
  SelectRoleModel({
    required this.isPaidRole,
    required this.role,
    this.isSelected = false,
  });

  void setSelect(bool value) {
    isSelected = value;
  }
}
