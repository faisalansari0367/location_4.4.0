// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/adapters.dart';

import '../../models/models.dart';

class EnvdStorageService {
  final Box box;
  EnvdStorageService({
    required this.box,
  });

  Future<void> saveToken(String username, EnvdTokenModel tokenModel) async {
    await box.put(username, tokenModel.toJson());
  }

  EnvdTokenModel? getToken(String username) {
    try {
      final data = box.get(username);
      if (data == null) {
        return null;
      }
      return EnvdTokenModel.fromJson(Map<String, dynamic>.from(data));
    } on Exception {
      rethrow;
    }
  }

  Future<void> saveConsignments(
      String userName, Consignments consignments) async {
    await box.put(consignmentsKey(userName), consignments.toJson());
  }

  Consignments? getConsignments(String userName) {
    final data = box.get(consignmentsKey(userName));
    if (data == null) {
      return null;
    }

    // if (data is Map) {
    //   _traverseMap(data);
    //   // for (var element in data.entries) {
    //   //   if(element.value is Map) {
    //   //     element.key
    //   //   }
    //   // }
    // }

    return Consignments.fromJson(
        Map<String, dynamic>.from(_traverseRead(data)));
  }

  String consignmentsKey(String userName) => '$userName-consignments';

  dynamic _traverseRead(dynamic value) {
    if (value is Map) {
      return value.map<String, dynamic>((dynamic key, dynamic value) {
        return MapEntry<String, dynamic>(
          _cast<String>(key) ?? '',
          _traverseRead(value),
        );
      });
    }
    if (value is List) {
      for (var i = 0; i < value.length; i++) {
        value[i] = _traverseRead(value[i]);
      }
    }
    return value;
  }

  T? _cast<T>(dynamic x) => x is T ? x : null;

  // _traverseList(List list) {
  //   for (var i = 0; i < list.length; i++) {
  //     final e = list[i];
  //     if (e is Map) {
  //       list[i] = Map<String, dynamic>.from(e);
  //       _traverseMap(e);
  //     } else if (e is List) {
  //       list[i] = List<Map<String, dynamic>>.from(e);
  //       _traverseList(e);
  //     }
  //   }
  // }
}
