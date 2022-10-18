import 'dart:io';

import 'package:background_location/services/notifications/forms_storage_service.dart';
import 'package:background_location/widgets/listview/my_listview.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class CvdForms extends StatefulWidget {
  const CvdForms({Key? key}) : super(key: key);

  @override
  State<CvdForms> createState() => _CvdFormsState();
}

class _CvdFormsState extends State<CvdForms> {
  Future<List<FileSystemEntity>> getDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.list().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text('CVD Forms'),
      ),
      body: FutureBuilder<List<FileSystemEntity>>(
        future: FormsStorageService().getCvdForms(),
        builder: (context, snapshot) {
          return MyListview(
            data: _sortData(snapshot.data ?? []),
            emptyWidget: Center(
              child: Text('No forms found'),
            ),
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () => OpenFile.open(snapshot.data![index].path),
                leading: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                ),
                title: Text(snapshot.data![index].path.split('/').last.replaceFirst('.', 'to')),
              );
            },
          );
        },
      ),
    );
  }

  DateTime getDateTime(FileSystemEntity file) {
    return DateTime.parse(file.path.split('CVD Form ').last);
  }

  List<FileSystemEntity> _sortData(List<FileSystemEntity> files) {
    // dd-mm--yy
    files.sort((a, b) => (b.statSync().accessed).compareTo(a.statSync().accessed));
    return files;
  }
}
