import 'dart:io';

class FormsHelper {
  final String cachePath;
  FormsHelper({
    required this.cachePath,
  });
  static const cvdFolder = 'cvd_forms';
  static const cvdDownloads = 'cvd_downloads';

  static Directory? _appDir;

  Future<Directory> _getCvdDir() async {
    if (_appDir != null) return _appDir!;
    final directory = Directory('$cachePath/$cvdFolder')..create();
    _appDir = directory;
    return _appDir!;
  }

  Future<Directory> getCvdDownloadsDir() async {
    final directory = Directory('$cachePath/$cvdDownloads')..create();
    // await directory.create();
    return directory;
  }

  Future<File> downloadCvd(String url) async {
    final Directory dir = await getCvdDownloadsDir();
    final file = await _createFile(path: dir.path, fileName: url);
    return file;
  }

  Future<File> createCvdFile(String fileName) async {
    final Directory dir = await _getCvdDir();
    final file = await _createFile(path: dir.path, fileName: fileName);
    return file;

    // return file;
  }

  Future<File> _createFile({
    required String path,
    required String fileName,
    String? fileExtension = 'pdf',
    int count = 0,
  }) async {
    final file =
        File('$path/$fileName${count == 0 ? '' : ' $count'}.$fileExtension');
    final isFileExist = await file.exists();
    if (!isFileExist) return await file.create(recursive: true);
    return _createFile(
      path: path,
      fileName: fileName,
      count: count + 1,
      fileExtension: fileExtension,
    );
  }
}
