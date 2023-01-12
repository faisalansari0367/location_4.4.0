import 'dart:io';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/services/notifications/forms_storage_service.dart';
import 'package:bioplus/widgets/listview/my_listview.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CvdForms extends StatefulWidget {
  const CvdForms({super.key});

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
      appBar: const MyAppBar(
        title: Text('CVD Forms'),
      ),
      body: FutureBuilder<List<FileSystemEntity>>(
        future: FormsStorageService(context.read<Api>()).getCvdForms(),
        builder: (context, snapshot) {
          return MyListview(
            data: _sortData(snapshot.data ?? []),
            emptyWidget: const Center(
              child: Text('No forms found'),
            ),
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () => OpenFile.open(snapshot.data![index].path),
                leading: const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red,
                ),
                title: Text(snapshot.data![index].path.split('/').last),
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
    files.sort(
      (a, b) => (b.statSync().accessed).compareTo(a.statSync().accessed),
    );
    return files;
  }
}
