import 'package:api_repo/api_repo.dart';
import 'package:bioplus/widgets/download_button/cvd_download_controller.dart';
import 'package:bioplus/widgets/download_button/download_controller.dart';
import 'package:bioplus/widgets/download_button/progress_button.dart';
import 'package:cvd_forms/cvd_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

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
    final controller = CvdDownloadController(
      cvdFormsRepo: context.read<Api>(),
      form: record,
    );
    return ListTile(
      onTap: () async {
        if (controller.downloadStatus.isDownloaded) {
          controller.openDownload();
        } else {
          await controller.startDownload();
          controller.openDownload();
        }
      },
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
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${record.buyerName}\n${record.createdAt?..microsecondsSinceEpoch}',
          ),
          ProgressButton(
            controller: controller,
          ),
        ],
      ),
      // subtitle: Text(MyDecoration.formatDate(record.createdAt)),
      // trailing: SizedBox(
      //   width: 100,
      //   child: LimitedBox(
      //     child: DownloadButton(
      //       controller: CvdDownloadController(
      //         // api: context.read<Api>(),
      //         cvdFormsRepo: context.read<Api>(),
      //         form: record,
      //       ),
      //     ),
      //   ),
      // ),
      trailing: IconButton(
        icon: const Icon(Icons.share),
        onPressed: () async {
          // controller.downloadStatus.isDownloaded
          //     ? Share.shareFiles([controller.downloadedFile!.path])
          //     : controller.startDownload();

          if (controller.downloadStatus.isDownloaded) {
            Share.shareFiles([controller.downloadedFile!.path]);
          } else {
            await controller.startDownload();
            Share.shareFiles([controller.downloadedFile!.path]);
          }
          // Share.shareFiles([controller.downloadedFile.path]);
        },
      ),
    );
  }
}
