import 'package:api_repo/api_repo.dart';
import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/widgets/dialogs/dialogs.dart';

class SosNotifier extends BaseModel {
  SosNotifier(super.context) {
    init();
  }
  List<SosNotification> _sosNotifications = [];

  List<SosNotification> get sosNotifications => _sosNotifications;

  Future<void> init() async {
    setLoading(true);
    final result = await api.getSosNotification();
    result.when(
      success: (data) {
        _sosNotifications = data;
        notifyListeners();
      },
      failure: (error) {
        DialogService.failure(error: error);
        notifyListeners();
      },
    );
    setLoading(false);
  }
}
