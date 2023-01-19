import 'dart:convert';

import 'package:bioplus/provider/base_model.dart';
import 'package:bioplus/ui/envd/models/envd_model.dart';
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
      final response = EnvdResponseModel.fromJson(map);
      items = response.data!.consignments!.items!;
    } on Exception {
      setLoading(false);
    }
    setLoading(false);
  }

  //
}
