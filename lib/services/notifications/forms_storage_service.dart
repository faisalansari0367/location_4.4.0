// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/my_decoration.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FormsStorageService {
  static const _cvdFolder = 'cvd_folder';
  static const _envd = 'envds';
  static const _csvs = 'csvs';
  static const _pdfs = 'pdfs';

  static Directory? _appDir;
  late User user;
  final Api api;

  FormsStorageService(
    this.api,
  ) {
    user = api.getUser()!;
    _getAppDir();
  }

  Future<Directory> _getAppDir() async {
    if (_appDir != null) return _appDir!;
    final directory = await getApplicationDocumentsDirectory();
    _appDir = directory;
    return _appDir!;
  }

  Future<Directory> _createOrCheckCvdFolder() async {
    // final directory = await _getAppDir();
    final directory = await _getUserDir();
    final dir = Directory('${directory.path}/$_cvdFolder');
    if (!(await dir.exists())) dir.create();
    return dir;
  }

  Future<Directory> _getUserDir() async {
    final appDir = await _getAppDir();
    final path = '${appDir.path}/${user.email}';
    await Permission.storage.request();
    final userDir = Directory(path);
    if (!(await userDir.exists())) userDir.create();
    return userDir;
  }

  Future<Directory> _createEnvdsDir() async {
    final appDir = await _getUserDir();
    final path = '${appDir.path}/$_envd';
    final envdDir = Directory(path);
    if (!(await envdDir.exists())) envdDir.create();
    return envdDir;
  }

  Future<File?> _checkEnvdExist(String consignmentNo) async {
    File? envd;
    final envdDir = await _createEnvdsDir();
    final envds = await envdDir.list().toList();
    for (final element in envds) {
      final file = File(element.path);
      final name = file.path.split('/').last;
      if (name.contains(consignmentNo)) {
        envd = file;
        break;
      }
    }
    return envd;
  }

  Future<File?> checkEnvdInCache(String consignmentNo) async {
    return _checkEnvdExist(consignmentNo);
  }

  Future<File> saveEnvdPdf(
    String url,
    String consignmentNo, {
    void Function(int, int)? onReceiveProgress,
  }) async {
    final envdDir = await _createEnvdsDir();
    final checkEnvd = await _checkEnvdExist(consignmentNo);
    if (checkEnvd != null) {
      // OpenFile.open(_checkEnvd.path);
      return checkEnvd;
    }
    final date = MyDecoration.formatDate(DateTime.now());
    final file = File('${envdDir.path}/$consignmentNo $date.pdf');
    final result =
        await api.downloadPdf(url, onReceiveProgress: onReceiveProgress);
    await file.writeAsBytes(result);
    return file;
    // OpenFile.open(file.path);
  }

  

  Future<File> _createCvdFile(
    String path,
    String date,
    String buyerName, {
    int count = 0,
  }) async {
    // final count = count ?? 0;
    final file =
        File('$path/${'$date $buyerName${count == 0 ? '' : ' $count'}.pdf'}');
    if (await file.exists()) {
      return _createCvdFile(path, date, buyerName, count: count + 1);
    } else {
      return file;
    }
  }

  Future<File> _createCsvFile(
    String path,
    String date,
    String fileName, {
    int count = 0,
  }) async {
    // final count = count ?? 0;
    final file =
        File('$path/${'$fileName $date ${count == 0 ? '' : count}.csv'}');
    if (await file.exists()) {
      return _createCsvFile(path, date, fileName, count: count + 1);
    } else {
      return file;
    }
  }

  Future<Directory> getCvdDir() async {
    final userDir = await _getUserDir();
    final cvdDir = Directory('${userDir.path}/$_cvdFolder');
    if (!(await cvdDir.exists())) cvdDir.create();
    return cvdDir;
  }

  Future<File> saveCvdForm(Uint8List bytes, String buyerName) async {
    final cvdDir = await getCvdDir();
    final date = MyDecoration.formatDate(DateTime.now());
    final file = await _createCvdFile(cvdDir.path, date, buyerName.trim());
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<List<FileSystemEntity>> getCvdForms() async {
    final cvdDir = await _createOrCheckCvdFolder();
    return cvdDir.list().toList();
  }

  Future<File> generateCsv(
    List<String> headers,
    List<List<String>> rows, {
    String? fileName,
  }) async {
    rows.insert(0, headers);
    final data = const ListToCsvConverter().convert(rows);
    final String directory = (await _getUserDir()).path;
    final csvDir = Directory('$directory/$_csvs');
    if (!(await csvDir.exists())) csvDir.create();
    final date = MyDecoration.formatDate(DateTime.now());
    final File file =
        await _createCsvFile(csvDir.path, date, fileName ?? 'csv');
    await file.writeAsString(data);
    return file;
  }

  Future<File> saveLogbookPdf({
    String? fileName,
    required Uint8List bytes,
    required LogbookEntry entry,
  }) async {
    final String directory = (await _getUserDir()).path;
    final pdfDir = Directory('$directory/$_pdfs');
    if (!(await pdfDir.exists())) pdfDir.create();
    final file = File(
      '${pdfDir.path}/${MyDecoration.formatDate(entry.createdAt)} ${entry.user!.fullName}.pdf',
    );
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<File> downloadPdf({String? fileName, required Uint8List bytes}) async {
    final String directory = (await _getUserDir()).path;
    final pdfDir = Directory('$directory/$_pdfs');
    if (!(await pdfDir.exists())) pdfDir.create();
    final file =
        File('${pdfDir.path}/${MyDecoration.formatDate(DateTime.now())}.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }
}

class FormsHelper {
  final String email;
  FormsHelper({
    required this.email,
  });

  static Directory? _appDir;

  Future<Directory> _getAppDir() async {
    if (_appDir != null) return _appDir!;
    final directory = await getApplicationDocumentsDirectory();
    _appDir = directory;
    return _appDir!;
  }

  Future<Directory> getUserDir() async {
    final appDir = await _getAppDir();
    final path = '${appDir.path}/$email';
    await Permission.storage.request();
    final userDir = Directory(path);
    if (!(await userDir.exists())) userDir.create();

    return userDir;
  }

  Future<File> createFile({
    required String path,
    required String fileName,
    String? fileExtension = 'pdf',
    int count = 0,
  }) async {
    final file =
        File('$path/$fileName ${count == 0 ? '' : count}.$fileExtension');

    if (!(await file.exists())) return file;

    return createFile(
      path: path,
      fileName: fileName,
      count: count + 1,
      fileExtension: fileExtension,
    );
  }
}
