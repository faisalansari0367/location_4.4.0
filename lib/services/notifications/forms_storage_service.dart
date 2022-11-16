// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:api_repo/api_repo.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/my_decoration.dart';

class FormsStorageService {
  static const _cvdFolder = 'cvd_folder';
  static const _envd = 'envds';

  static Directory? _appDir;
  late User user;
  final Api api;

  FormsStorageService(
    this.api,
  ) {
    this.user = api.getUser()!;
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
    final userDir = Directory(path);
    if (!(await userDir.exists())) userDir.create(recursive: false);
    return userDir;
  }

  Future<Directory> _createEnvdsDir() async {
    final appDir = await _getUserDir();
    final path = '${appDir.path}/$_envd';
    final envdDir = Directory(path);
    if (!(await envdDir.exists())) envdDir.create(recursive: false);
    return envdDir;
  }

  Future<File?> _checkEnvdExist(String consignmentNo) async {
    File? _file;
    final envdDir = await _createEnvdsDir();
    final envds = (await envdDir.list().toList());
    for (var element in envds) {
      final file = File(element.path);
      final name = file.path.split('/').last;
      if (name.contains(consignmentNo)) {
        _file = file;
        break;
      }
    }
    return _file;
  }

  Future<File?> checkEnvdInCache(String consignmentNo) async {
    return _checkEnvdExist(consignmentNo);
  }

  Future<File> saveEnvdPdf(String url, String consignmentNo, {void Function(int, int)? onReceiveProgress}) async {
    final envdDir = await _createEnvdsDir();
    final _checkEnvd = await _checkEnvdExist(consignmentNo);
    if (_checkEnvd != null) {
      // OpenFile.open(_checkEnvd.path);
      return _checkEnvd;
    }
    final date = MyDecoration.formatDate(DateTime.now());
    final file = File('${envdDir.path}/${consignmentNo} ${date}.pdf');
    final result = await api.downloadPdf(url, onReceiveProgress: onReceiveProgress);
    await file.writeAsBytes(result);
    return file;
    // OpenFile.open(file.path);
  }

  Future<String> createCvdFileName() async {
    var count = 1;
    final cvdDir = await _createOrCheckCvdFolder();
    final files = await getCvdForms();

    if (files.isNotEmpty) {
      count = files.length + 1;
    }

    final path = '${cvdDir.path}/${user.email}/${'CVD Form $count.pdf'}';
    return path;
  }

  Future<File> _createCvdFile(String path, String date, String buyerName, {int? count}) async {
    var _count = count ?? 0;
    final file = File('${path}/${'$date $buyerName ${_count == 0 ? '' : _count}.pdf'}');
    if (await file.exists()) {
      // final _newpath = '${path}/${'$date $buyerName ${_count == 0 ? '' : _count}.pdf'}';
      return _createCvdFile(path, date, buyerName, count: _count + 1);
    } else {
      // await file.create();
      return file;
    }
  }

  Future<File> saveCvdForm(Uint8List bytes, String buyerName) async {
    final userDir = await _getUserDir();
    final cvdDir = Directory(userDir.path + '/$_cvdFolder');
    if (!(await cvdDir.exists())) cvdDir.create();
    final date = MyDecoration.formatDate(DateTime.now());
    // final path = '${cvdDir.path}/${'$date $buyerName.pdf'}';
    final file = await _createCvdFile(cvdDir.path, date, buyerName);
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<List<FileSystemEntity>> getCvdForms() async {
    final cvdDir = await _createOrCheckCvdFolder();
    return cvdDir.list().toList();
  }
}
