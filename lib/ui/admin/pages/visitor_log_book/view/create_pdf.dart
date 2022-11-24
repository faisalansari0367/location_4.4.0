import 'dart:developer';
import 'dart:io';

import 'package:api_repo/api_repo.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../../constants/my_decoration.dart';

class CreatePDf {
  static createLogbookPDf(List<String> headers, List<List<String>> rows) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Log Records', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
          pw.Table.fromTextArray(
            headers: headers,
            data: rows,
          ),
        ],
      ),
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);
    } catch (e) {
      log(e.toString());
    }
  }

  static void printDeclarationForm(LogbookEntry data) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // zone
              pw.Container(
                // padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                    // border: pw.Border.all(color: PdfColors.black),
                    // borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                    ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (data.geofence?.name != null)
                      pw.Text(
                        'Geofence Name: ${data.geofence!.name}',
                        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                    pw.SizedBox(height: 10),
                    if (data.geofence?.pic != null)
                      pw.Text(
                        'Geofence PIC: ${data.geofence!.pic}',
                        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                    pw.SizedBox(height: 10),
                    if (data.user?.fullName != null)
                      pw.Text(
                        'Visitor Name: ${data.user?.fullName}',
                        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                    pw.SizedBox(height: 20),
                    pw.Divider(),
                  ],
                ),
              ),
              // managers name

              // visitors name

              // for (final item in data.form) getWidget(item),
            ],
          ); // Center
        },
      ),
    ); // Page

    try {
      final directory = await getApplicationDocumentsDirectory();
      // final file = File('${directory.path}/${DateTime.now().millisecondsSinceEpoch}.pdf');
      final file = File('${directory.path}/${MyDecoration.formatDate(data.createdAt)} ${data.user!.fullName}.pdf');

      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);
    } catch (e) {
      log(e.toString());
    }
  }

  // static pw.Widget getWidget(LogbookFormField field) {
  //   switch (field.field!.toLowerCase()) {
  //     case 'signature:':
  //     case 'signature':
  //       final image = pw.MemoryImage(
  //         base64Decode(field.value),
  //       );
  //       return pw.Image(image, height: 100, width: 100);

  //     case 'day/date/time':
  //       return _field(field.field!, MyDecoration.formatDateTime(DateTime.tryParse(field.value!)));
  //     case 'time':
  //     case 'expected departure time':
  //       return _field(field.field!, MyDecoration.formatTime(DateTime.tryParse(field.value!)));
  //     case 'date':
  //     case 'expected departure date':
  //       return _field(field.field!, MyDecoration.formatDate(DateTime.tryParse(field.value!)));
  //     default:
  //       if (field.value is List) {
  //         return _field(field.field!, field.value.join(', '));
  //       }
  //       return _field(field.field!, field.value!);
  //   }
  // }

  static pw.Widget _field(String key, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(key, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 5),
        pw.Text(
          value.toUpperCase(),
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.normal,
            color: value.toUpperCase() == 'NO' ? PdfColors.red : PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }
}
