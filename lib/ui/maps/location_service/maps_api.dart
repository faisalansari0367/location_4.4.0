// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/configs/client.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:rxdart/subjects.dart';

class _Endpoints {
  static const String locations = '/locations';
}

class MapsApi implements MapsRepo {
  final Client client;
  MapsApi({
    required this.client,
  }) {
    getAllPolygon();
  }
  final _controller = BehaviorSubject<List<PolygonModel>>.seeded([]);
  @override
  Future<ApiResult<List<PolygonModel>>> getAllPolygon() async {
    try {
      final result = await client.get(_Endpoints.locations);
      final data = (result.data['data'] as List<dynamic>).map((e) => PolygonModel.fromJson(e)).toList();
      _controller.add(data);
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
    // throw UnimplementedError();
  }

  @override
  Future<void> init() async {}

  @override
  Stream<List<PolygonModel>> get polygonStream => _controller.stream;

  @override
  Future<void> savePolygon(PolygonModel model) async {
    final data = model.toJson()..remove('id');
    try {
      final result = await client.post(_Endpoints.locations, data: data);
      print(result);
      _controller.add([..._controller.value, model]);
      getAllPolygon();
      // return ApiResult.success(data: result.data);
    } on Exception catch (e) {
      print(e);
      // return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
