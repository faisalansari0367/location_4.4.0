import 'dart:io';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/services/notifications/forms_storage_service.dart';
import 'package:csv/csv.dart';

class CsvService {
  final Api api;

  CsvService(this.api);

  Future<File> generateCsv(
    List<String> headers,
    List<List<String>> rows, {
    String? fileName,
  }) async {
    final FormsStorageService service = FormsStorageService(api);
    final dir = await service.getCsvsDir();
    final newHeaders = headers.map((e) => e.toUpperCase()).toList();
    rows.insert(0, newHeaders);
    final data = const ListToCsvConverter().convert(rows);
    final name = fileName ?? 'csv-${DateTime.now()}';
    final path = "${dir.path}/$name.csv";
    final File file = File(path);
    await file.writeAsString(data);
    return file;
  }
}
