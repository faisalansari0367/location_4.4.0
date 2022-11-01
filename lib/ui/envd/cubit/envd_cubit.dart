import 'dart:convert';

import 'package:background_location/provider/base_model.dart';
import 'package:background_location/ui/envd/models/envd_model.dart';
import 'package:flutter/cupertino.dart';

class EnvdCubit extends BaseModel {
  EnvdCubit(BuildContext context) : super(context) {
    _fetchEnvdData(context);
  }
  List<Items> items = [];

  // load json
  Future<void> _fetchEnvdData(BuildContext context) async {
    setLoading(true);
    try {
      final data = await DefaultAssetBundle.of(context).loadString('assets/json/envd_data.json');
      final map = jsonDecode(data);
      final _response = EnvdResponseModel.fromJson(map);
      items = _response.data!.consignments!.items!;
    } on Exception {
      setLoading(false);
    }
    setLoading(false);
  }

  //
}