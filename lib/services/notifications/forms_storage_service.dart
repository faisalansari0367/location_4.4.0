import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class FormsStorageService {
  static const _cvdFolder = 'cvd_folder';
  static Directory? _appDir;

  FormsStorageService() {
    _getAppDir();
  }

  Future<Directory> _getAppDir() async {
    if (_appDir != null) return _appDir!;
    final directory = await getApplicationDocumentsDirectory();
    _appDir = directory;
    return _appDir!;
  }

  Future<Directory> _createOrCheckCvdFolder() async {
    final directory = await _getAppDir();
    final dir = Directory('${directory.path}/$_cvdFolder');
    if (!(await dir.exists())) dir.create();
    return dir;
  }

  Future<File> saveCvdForm(Uint8List bytes) async {
    final cvdDir = await _createOrCheckCvdFolder();
    final file = File('${cvdDir.path}/${'CVD Form'} ${DateTime.now().toString()}.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<List<FileSystemEntity>> getCvdForms() async {
    final cvdDir = await _createOrCheckCvdFolder();
    return cvdDir.list().toList();
  }
}
