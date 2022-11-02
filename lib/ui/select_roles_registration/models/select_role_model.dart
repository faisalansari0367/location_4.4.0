
class SelectRoleModel {
  final String role;
  bool isSelected;
  SelectRoleModel({
    required this.role,
    this.isSelected = false,
  });

  setSelect(bool value) {
    isSelected = value;
  }
}
