import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/cvd_record/provider/provider.dart';
import 'package:bioplus/ui/cvd_record/widgets/online_records.dart';
import 'package:bioplus/widgets/empty_screen.dart';
import 'package:bioplus/widgets/listview/my_listview.dart';
import 'package:bioplus/widgets/upload/upload_widget.dart';
import 'package:cvd_forms/models/src/cvd_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

/// {@template cvd_record_body}
/// Body of the CvdRecordPage.
///
/// Add what it does
/// {@endtemplate}
class CvdRecordBody extends StatelessWidget {
  /// {@macro cvd_record_body}
  const CvdRecordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CvdRecordNotifier>(
      builder: (context, state, child) {
        // if (state.files.isEmpty) {
        //   return SizedBox(
        //     child: EmptyScreen(),
        //     height: 50.height,
        //   );
        // }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // StreamBuilder<bool>(
              //   stream: MyConnectivity().connectionStream,
              //   initialData: false,
              //   builder: (context, snapshot) {
              //     return Visibility(
              //       visible: state.forms.isNotEmpty && snapshot.data == true,
              //       child: UploadProgress(
              //         controller: SyncService().syncCvdController,
              //       ),
              //     );
              //   },
              // ),
              Visibility(
                maintainState: true,
                maintainAnimation: true,
                visible: state.forms.isNotEmpty,
                child: UploadProgress(
                  controller: state.cvdController,
                ),
              ),
              if (state.onlineRecords.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Online Records',
                    style: context.textTheme.headline6,
                  ),
                ),
              ],
              CvdOnlineRecords(records: state.onlineRecords),

              if (state.forms.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Offline Records',
                    style: context.textTheme.headline6,
                  ),
                ),
                _buildPdfs(state),
                Gap(20.h),
              ]
              // else ...[
              //   SizedBox(
              //     height: 70.height,
              //     child: const Center(
              //       child: EmptyScreen(
              //         message: 'No Offline Records Found',
              //         // subtitle: 'Please fill the form to get records',
              //       ),
              //     ),
              //     // height: 50.height,
              //   ),
              // ],
              // if (state.forms.isNotEmpty) ...[
              //   Padding(
              //     padding: const EdgeInsets.all(12.0),
              //     child: Text(
              //       'Offline Records',
              //       style: context.textTheme.headline6,
              //     ),
              //   ),
              //   offlineRecords(state),
              // ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPdfs(CvdRecordNotifier state) {
    return MyListview(
      shrinkWrap: true,
      data: state.forms,
      spacing: Divider(
        color: Colors.grey.shade300,
        height: 2,
        thickness: 1,
      ),
      emptyWidget: SizedBox(
        height: 50.height,
        child: const EmptyScreen(),
      ),
      itemBuilder: (BuildContext context, p1) {
        final cvdForm = state.forms[p1];
        final file = File(cvdForm.filePath!);
        return ListTile(
          onTap: () => OpenFile.open(file.path),
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
          trailing: PopupMenuButton(
            onSelected: (value) {
              switch (value) {
                case 1:
                  Share.shareFiles([file.path]);
                  break;
                case 2:
                  state.deleteForm(cvdForm);
                  break;
                case 3:
                  state.uploadForm(cvdForm);
                  break;
              }
            },
            shape: const RoundedRectangleBorder(
              borderRadius: kBorderRadius,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    const Icon(Icons.share),
                    Gap(10.w),
                    const Text('Share'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    const Icon(Icons.delete),
                    Gap(10.w),
                    const Text('Delete'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: [
                    const Icon(Icons.upload_file),
                    Gap(10.w),
                    const Text('Upload'),
                  ],
                ),
              ),
            ],
          ),
          title: Text(
            file.path.split('/').last,
            style: context.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }

  Widget _buildRow(String field1, String value1, String field2, String value2) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildText(field1, value1),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: _buildText(field2, value2),
        ),
      ],
    );
  }

  Widget _buildText(String text, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          text,
          maxLines: 1,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(5.h),
        AutoSizeText(
          value,
          maxLines: 1,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  MyListview<CvdForm> offlineRecords(CvdRecordNotifier state) {
    return MyListview(
      data: state.forms,
      shrinkWrap: true,
      // spacing: Divider(),
      emptyWidget: SizedBox(
        height: 50.height,
        child: const EmptyScreen(),
      ),
      itemBuilder: (BuildContext context, p1) {
        final form = state.forms[p1];

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: kBorderRadius,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IconButton(
              //   icon: Icon(Icons.cloud_off_outlined),
              //   onPressed: () {},
              // ),
              // Gap(10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildText(
                    'Buyer',
                    (form.buyerDetailsModel?.name?.value ?? '').capitalize!,
                  ),
                  Gap(5.w),
                  _buildText(
                    'Transporter',
                    (form.transporterDetails?.name?.value ?? '').capitalize!,
                  ),
                  // Gap(5.w),
                  // _buildText('Date', form.transporterDetails?.name?.value ?? ''),
                  // _buildText('Date', MyDecoration.formatDate(form.createdAt ) ?? ''),
                ],
              ),
              const Spacer(),
              Column(
                children: const [
                  // IconButton(
                  //   icon: Icon(Icons.cloud_off_outlined),
                  //   onPressed: () {},
                  // ),
                  Icon(
                    Icons.cloud_off_outlined,
                    color: Colors.orange,
                  ),
                  Text(
                    'Offline',
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_right_outlined),
              ),
            ],
          ),
        );
      },
    );
  }
}
