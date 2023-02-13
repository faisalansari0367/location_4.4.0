import 'package:api_client/api_result/api_result.dart';

import 'models/models.dart';

abstract class PicRepo {
  Future<ApiResult<List<PicModel>>> getPics();
  Future<ApiResult<PicModel>> createPic({required AddPicParams params});
  Future<ApiResult<PicModel>> updatePic({
    required AddPicParams params,
    required int picId,
  });

  Stream<List<PicModel>> get picsStream;
  List<PicModel> get pics;
}
