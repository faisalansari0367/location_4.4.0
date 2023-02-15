import 'package:api_repo/api_repo.dart';
import 'package:bioplus/provider/base_model.dart';

class EnvdCubit extends BaseModel {
  EnvdCubit(super.context) {
    // _fetchEnvdData(context);
    final EnvdRepo envdRepo = api;
    api.getPics();

  }

  bool get isVisitor => api.getUserData()?.role == 'Visitor';

  Stream<List<PicModel>> get picsStream => api.picsStream;
}
