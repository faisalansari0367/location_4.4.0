// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class FileSaver {
//   Future<void> saveAndOpenFile(Uint8List pdf) async {
//     final path = (await getApplicationDocumentsDirectory()).path;
//     await Permission.storage.request();
//     final file = File('$path/cvd.pdf');
//     if (await file.exists()) {
//       await file.delete();
//       await file.create();
//     } else {
//       await file.create();
//     }
//     await file.writeAsBytes(pdf, flush: true);
//     await OpenFile.open(file.path);
//   }
// }
