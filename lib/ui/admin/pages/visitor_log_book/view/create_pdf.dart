import 'dart:developer';
import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
                // pw.PdfLogo(),
                // pw.Image(),
              ],
            ),
          ),
          pw.Table.fromTextArray(
            headers: headers,
            // ),
            data: rows,
            // data: [
            //   for (var row in rows)
            //           pw.TableRow(
            //             children: row
            //                 .map(
            //                   (e) => pw.Padding(
            //                     padding: pw.EdgeInsets.all(4),
            //                     child: pw.Text(e),
            //                   ),
            //                 )
            //                 .toList(),
            //           )
            // ],
          ),
        ],
      ),
      // pw.Page(

      //   pageFormat: PdfPageFormat.a4,

      //   build: (context) {
      //     return pw.Column(
      //       children: [
      //         pw.Text(
      //           'Log Records',
      //           style: pw.TextStyle(
      //             fontSize: 20,
      //             fontWeight: pw.FontWeight.bold,
      //           ),
      //         ),
      //         pw.SizedBox(height: 20),
      //         pw.Expanded(
      //           child: pw.Table(
      //             border: pw.TableBorder.all(),
      //             children: [
      //               pw.TableRow(
      //                 children: headers
      //                     .map(
      //                       (e) => pw.Padding(
      //                         padding: pw.EdgeInsets.all(4),
      //                         child: pw.Text(
      //                           e,
      //                           style: pw.TextStyle(
      //                             fontSize: 14,
      //                             fontWeight: pw.FontWeight.bold,
      //                           ),
      //                         ),
      //                       ),
      //                     )
      //                     .toList(),
      //               ),
      //               for (var row in rows)
      //                 pw.TableRow(
      //                   children: row
      //                       .map(
      //                         (e) => pw.Padding(
      //                           padding: pw.EdgeInsets.all(4),
      //                           child: pw.Text(e),
      //                         ),
      //                       )
      //                       .toList(),
      //                 )
      //             ],
      //             // child: Text('Hello World'),
      //           ),
      //         ),
      // ],
      // );
      // },
      // ),
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
}
