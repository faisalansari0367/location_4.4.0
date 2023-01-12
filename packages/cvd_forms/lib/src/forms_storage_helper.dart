import 'dart:io';

class FormsHelper {
  final String cachePath;
  FormsHelper({
    required this.cachePath,
  });
  static const cvdFolder = 'cvd_forms';
  static Directory? _appDir;

  Future<Directory> _getCvdDir() async {
    if (_appDir != null) return _appDir!;
    final directory = Directory('$cachePath/cvd_forms')..create();
    _appDir = directory;
    return _appDir!;
  }

  Future<File> createCvdFile(String fileName) async {
    final Directory dir = await _getCvdDir();
    final file = await _createFile(path: dir.path, fileName: fileName);
    return file;
  }

  Future<File> _createFile({
    required String path,
    required String fileName,
    String? fileExtension = 'pdf',
    int count = 0,
  }) async {
    final file =
        File('$path/$fileName${count == 0 ? '' : ' $count'}.$fileExtension');
    if (!(await file.exists())) return file;
    return _createFile(
      path: path,
      fileName: fileName,
      count: count + 1,
      fileExtension: fileExtension,
    );
  }
}
