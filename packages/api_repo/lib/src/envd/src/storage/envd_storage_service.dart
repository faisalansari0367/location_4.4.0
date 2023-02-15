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
    final data = box.get(username);
    if (data == null) {
      return null;
    }
    return EnvdTokenModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> saveConsignments(
      String username, Consignments consignments) async {
    await box.put(username, consignments.toJson());
  }

  Consignments? getConsignments(String username) {
    final data = box.get(username);
    if (data == null) {
      return null;
    }
    return Consignments.fromJson(Map<String, dynamic>.from(data));
  }
}
