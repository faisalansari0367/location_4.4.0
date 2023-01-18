import 'package:cvd_forms/models/models.dart';
import 'package:flutter/material.dart';

class CvdOnlineRecords extends StatelessWidget {
  final List<CvdModel> records;
  const CvdOnlineRecords({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: _itemBuilder,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: records.length,
      shrinkWrap: true,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final record = records[index];
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          color: Color.fromARGB(203, 255, 205, 210),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.picture_as_pdf,
          color: Colors.red,
        ),
      ),
      title: Text(record.cvdName),
      subtitle: Text(record.pic ?? ''),
      trailing: IconButton(
        icon: const Icon(Icons.share),
        onPressed: () {
          // Share.shareFiles([records[index].path]);
        },
      ),
    );
  }
}
