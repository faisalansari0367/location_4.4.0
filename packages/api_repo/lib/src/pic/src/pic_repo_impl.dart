// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_client/api_client.dart';
import 'package:api_client/configs/client.dart';
import 'package:rxdart/subjects.dart';

import 'models/models.dart';
import 'pic_repo.dart';

class PicRepoImpl implements PicRepo {
  final Client client;
  PicRepoImpl({
    required this.client,
  });

  final BehaviorSubject<List<PicModel>> _pics =
      BehaviorSubject.seeded(List<PicModel>.empty());

  @override
  Future<ApiResult<List<PicModel>>> getPics() async {
    try {
      final result = await client.get(Endpoints.getAllPics);
      final model = result.data['data'];
      final list = model
          .map<PicModel>((e) => PicModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      _pics.add(list);
      return ApiResult.success(data: list);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<PicModel>> createPic({required AddPicParams params}) async {
    try {
      final result =
          await client.post(Endpoints.createPic, data: params.toJson());
      final model = result.data['data'];
      final PicModel picModel =
          PicModel.fromJson(Map<String, dynamic>.from(model));
      _pics.add([..._pics.value, picModel]);
      return ApiResult.success(data: picModel);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<PicModel>> updatePic(
      {required AddPicParams params, required int picId}) async {
    try {
      final result = await client.patch(
        Endpoints.updatePic + picId.toString(),
        data: params.toJson()
          ..remove('pic')
          ..remove('ngr')
          ..remove('company_name')
          ..remove('property_name')
          ..remove('owner')
          ..remove('street')
          ..remove('town')
          ..remove('postcode'),
      );
      final data = Map<String, dynamic>.from(result.data['data']);
      final PicModel picModel = PicModel.fromJson(data);
      final index = _pics.value.indexWhere((element) => element.id == picId);
      final list = _pics.value;
      list[index] = picModel;
      _pics.add(list);
      return ApiResult.success(data: picModel);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  List<PicModel> get pics => _pics.value;

  @override
  Stream<List<PicModel>> get picsStream => _pics.stream;
}
