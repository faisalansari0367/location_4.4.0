import 'package:api_repo/api_repo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:background_location/constants/index.dart';
import 'package:background_location/services/notifications/forms_storage_service.dart';
import 'package:background_location/ui/envd/models/envd_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EnvdListItem extends StatelessWidget {
  final Items items;
  const EnvdListItem({Key? key, required this.items}) : super(key: key);

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
                ? MyDecoration.formatDate(DateTime.parse(items.submittedAt ?? items.updatedAt!))
                : '',
          ),
          _gap(),
          _buildRow('From PIC', items.origin!.pic!, 'To PIC', items.destination!.pic!),
          _gap(),
          _buildRow('Species', items.species!, 'Quantity', _getQuantity()),
          _gap(),
          _buildText('Accreditations', _getAccredentials()),
          _gap(),
          _buildRow('Transporter', _findById('158')?.value ?? '', 'Mobile', _findById('160')?.value ?? ''),
          _gap(),
          Row(
            children: [
              _buildText('Status', items.status!),
              Spacer(),
              _buildPdfButton(context),
            ],
          ),
        ],
      ),
    );
  }

  String _getAccredentials() {
    List<String> availableTypes = [];
    final ahsType = 'HS${items.species!.characters.first}';
    final msaType = 'MSA${items.species!.characters.first}'; //MSAC1
    final nfasType = 'NFAS${items.species!.characters.first}';

    final ahsResults = items.forms!.where((element) => (element.type ?? '').contains(ahsType));
    if (ahsResults.isNotEmpty) availableTypes.add('AHS');
    final msaResults = items.forms!.where((element) => (element.type ?? '').contains(msaType));
    if (msaResults.isNotEmpty) availableTypes.add('MSA');
    final nfasResults = items.forms!.where((element) => (element.type ?? '').contains(nfasType));
    if (nfasResults.isNotEmpty) availableTypes.add('NFAS');
    return availableTypes.join(' , ');
  }

  Answers? _findById(String id) {
    final data = items.answers!.where((element) => element.questionId == id);
    if (data.isEmpty) return null;
    return data.first;
  }

  Widget _buildRow(String field1, String value1, String field2, String value2) {
    return Row(
      children: [
        Expanded(child: _buildText(field1, value1)),
        Spacer(),
        Expanded(child: _buildText(field2, value2)),
      ],
    );
  }

  Widget _gap() => const Divider();

  Widget _buildPdfButton(BuildContext context) {
    return Align(
      // alignment: Alignment.centerRight,
      child: OutlinedButton.icon(
        icon: Icon(Icons.picture_as_pdf),
        label: Text('View PDF'),
        style: ElevatedButton.styleFrom(
          // primary: Color.fromARGB(255, 244, 54, 54),
          // onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        // text: 'View PDf',
        // width: 10.width,
        // padding: EdgeInsets.all(0),
        onPressed: () {
          if (items.pdfUrl != null) openPdf(context, items.pdfUrl!);
        },
      ),
    );
  }

  Future<void> openPdf(BuildContext context, String url) async {
    final api = context.read<Api>();
    final formsService = FormsStorageService(api);
    final result = await formsService.saveEnvdPdf(url, items.number!);
    // result.when(
    //   success: (s) async {
    //     final directory = await getApplicationDocumentsDirectory();
    //     final file = File('${directory.path}/${DateTime.now().millisecondsSinceEpoch}.pdf');
    //     await file.writeAsBytes(s);
    //     await OpenFile.open(file.path);
    //   },
    //   failure: (e) => DialogService.failure(error: e),
    // );
  }

  Widget _buildText(String text, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          text,
          maxLines: 1,
          style: TextStyle(
            // color: _getColors().computeLuminance() >= 0.5 ? Colors.grey.shade600 : Colors.white70,
            color: Colors.grey.shade600,
          ),
        ),
        Gap(5.h),
        AutoSizeText(
          value,
          maxLines: 1,
          style: TextStyle(
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
    print(type);
    switch (type) {
      case 'LPAG2':
        return Color(0xffDC4233);
      case 'LPAC1':
        return Color(0XFFFAE26C);
      case 'LPASL1':
        return Color(0xff90519B);
      case 'LPABC1':
        return Color(0XFF388068);
      case 'EUC1':
        return Color(0xffAACE74);
      default:
        return Colors.transparent;
    }
  }

  String _getQuantity() {
    final data = items.answers!.where((element) => element.questionId == '3');
    if (data.isEmpty) return '';
    return data.first.value!;
  }
}
