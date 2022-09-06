// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:api_repo/api_result/api_result.dart';
import 'package:api_repo/api_result/network_exceptions/network_exceptions.dart';
import 'package:api_repo/configs/client.dart';
import 'package:background_location/ui/maps/location_service/maps_repo.dart';
import 'package:background_location/ui/maps/models/polygon_model.dart';
import 'package:rxdart/subjects.dart';

class _Endpoints {
  static const String geofences = '/geofences';
  static String geofence(String? id) => '/geofences/$id';

  // static const String notifyManager = '/notifyManager';
  static const String notifyProperyManager = '/users/notify-property-manager';
  static const String registerEntryToLogbook = '/users/register-entry-to-logbook';
}

class MapsApi implements MapsRepo {
  final Client client;
  MapsApi({required this.client}) {
    // getAllPolygon();
  }

  final _controller = BehaviorSubject<List<PolygonModel>>.seeded([]);

  @override
  Future<ApiResult<List<PolygonModel>>> getAllPolygon() async {
    try {
      final result = await client.get(_Endpoints.geofences);
      final data = (result.data['data'] as List<dynamic>).map((e) => PolygonModel.fromJson(e)).toList();
      _controller.add(data);
      return ApiResult.success(data: data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
    // throw UnimplementedError();
  }

  @override
  Future<void> init() async {
    getAllPolygon();
  }

  @override
  Stream<List<PolygonModel>> get polygonStream => _controller.stream;

  @override
  Future<ApiResult<void>> savePolygon(PolygonModel model) async {
    final data = model.toJson()..remove('id');
    try {
      final result = await client.post(_Endpoints.geofences, data: data);
      print(result);
      _controller.add([..._controller.value, model]);
      getAllPolygon();

      return ApiResult.success(data: result.data);
    } on Exception catch (e) {
      print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<void>> updatePolygon(PolygonModel model) async {
    try {
      final data = model.toJson()..remove('id');
      final result = await client.patch(_Endpoints.geofence(model.id), data: data);
      // print(result);
      final list = _controller.value;
      final index = list.indexWhere((element) => element.id == model.id);
      list[index] = model;
      _controller.add(list);
      getAllPolygon();
      return ApiResult.success(data: result.data);
    } on Exception catch (e) {
      print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> notifyManager(String pic, String lat, String lng, String locationId) async {
    try {
      final result = await client.post(_Endpoints.notifyProperyManager, data: {
        'pic': pic,
        'latitude': lat,
        'longitude': lng,
        'geofenceID': locationId,
      });
      // print(result);
      // _controller.add([..._controller.value, model]);
      // getAllPolygon();

      return ApiResult.success(data: result.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> logBookEntry(String pic, String? form, String locationId) async {
    try {
      final result = await client.post(_Endpoints.registerEntryToLogbook, data: {
        'pic': pic,
        'form': form ?? '[]',
        'geofenceID': locationId,
      });
      return ApiResult.success(data: result.data);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  void cancel() {
    // _controller.value.a);
    _controller.add(<PolygonModel>[]);
  }

  // @override
  // Future<ApiResult> updateLocation(PolygonModel model) {
  //   throw UnimplementedError();
  // }
}
