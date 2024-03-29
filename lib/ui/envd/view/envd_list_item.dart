import 'package:api_repo/api_repo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/services/notifications/forms_storage_service.dart';
// import 'package:bioplus/ui/envd/models/envd_model.dart';
import 'package:bioplus/widgets/download_button/download_button.dart';
import 'package:bioplus/widgets/download_button/envd_download_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnvdListItem extends StatelessWidget {
  final Items items;
  const EnvdListItem({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kPadding,
      decoration: BoxDecoration(
        border: Border.all(
          color: _getColors(),
          width: 6,
        ),
        color: Colors.white,
        borderRadius: kBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(
            'Consignment',
            items.number!,
            'Created',
            items.submittedAt != null || items.updatedAt != null
                ? MyDecoration.formatDate(
                    DateTime.parse(items.submittedAt ?? items.updatedAt!),
                  )
                : '',
          ),
          _gap(),
          _buildRow(
            'From PIC',
            items.origin!.pic!,
            'To PIC',
            items.destination!.pic!,
          ),
          _gap(),
          _buildRow('Species', items.species!, 'Quantity', items.getQuantity()),
          _gap(),
          _buildRow('Breed', items.breed, 'Breed Sex', items.breedSex),
          _gap(),
          _buildRow(
            'Transporter',
            items.transporter,
            'Mobile',
            items.mobile,
          ),
          _gap(),
          _buildText('Accreditations', items.getAccredentials()),
          _gap(),
          Row(
            children: [
              _buildText('Status', items.status!),
              const Spacer(),
              _buildPdfButton(context),
            ],
          ),
        ],
      ),
    );
  }

  // Answers? _findById(String id) {
  //   final data = items.answers!.where((element) => element.questionId == id);
  //   if (data.isEmpty) return null;
  //   return data.first;
  // }

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

  Widget _gap() => const Divider();

  Widget _buildPdfButton(BuildContext context) {
    return Flexible(
      flex: 2,
      child: DownloadButton(
        buttonText: 'Download PDF',
        controller: EnvdDownloadController(
          api: context.read<Api>(),
          consignmentNo: items.number!,
          downloadUrl: items.pdfUrl!,
          // onOpenDownload: () {},
        ),
      ),
    );
  }

  Future<void> openPdf(BuildContext context, String url) async {
    final api = context.read<Api>();
    final formsService = FormsStorageService(api);
    await formsService.saveEnvdPdf(url, items.number!);
  }

  Widget _buildText(String text, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          text,
          maxLines: 1,
          style: TextStyle(
            color: Colors.grey.shade600,
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

  Color _getColors() {
    String type = '';

    if (items.forms?.isNotEmpty ?? false) {
      type = items.forms!.first.type!;
    }
    switch (type) {
      case 'LPAG2':
        return const Color(0xffDC4233);
      case 'LPAC1':
        return const Color(0XFFFAE26C);
      case 'LPASL1':
        return const Color(0xff90519B);
      case 'LPABC1':
        return const Color(0XFF388068);
      case 'EUC1':
        return const Color(0xffAACE74);
      default:
        return Colors.transparent;
    }
  }
}
