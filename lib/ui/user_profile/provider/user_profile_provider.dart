import 'package:api_repo/api_repo.dart';
import 'package:bioplus/provider/base_model.dart';

class UserProfileNotifier extends BaseModel {
  final int _count = 0;

  UserProfileNotifier(super.context);

  UserData? get user => apiService.getUserData();
}
