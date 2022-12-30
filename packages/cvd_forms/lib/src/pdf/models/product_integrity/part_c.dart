import 'dart:convert';

import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;

import '../../widgets/basic_pdf_widgets.dart';

class ProductIntegrityPartC {
  final String signature;
  final String organisationName;
  final String name;

  ProductIntegrityPartC({
    required this.signature,
    required this.organisationName,
    required this.name,
  });

  pw.Widget selfDeclaration() {
    final declaration = [
      'I am the duly authorised representative of the vendor supplying the commodity.',
      'All the information in this document is true and correct;',
      'I have read, understood and answered all questions in accordance with the explanatory notes.',
      'I understand that regulatory authorities may take legal action, and purchasers may seek damages if the information provided is false or misleading',
    ];
    return Widgets.drawBox(
      title: 'Part C - Declaration',
      child: Widgets.column(
        children: [
          pw.RichText(
            text: pw.TextSpan(
              style: const pw.TextStyle(color: pdf.PdfColors.black),
              children: <pw.TextSpan>[
                const pw.TextSpan(
                  text: 'I ',
                  style: pw.TextStyle(
                      // fontWeight: pw.FontWeight.bold,
                      ),
                ),
                pw.TextSpan(
                  text: name,
                  style: pw.TextStyle(
                    // fontBold: pw.Font.helvetica(),
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.TextSpan(
                  text: ' of ',
                  style: pw.TextStyle(
                    // fontBold: pw.Font.helvetica(),
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
                pw.TextSpan(
                  text: '$organisationName ',
                  style: pw.TextStyle(
                    // fontBold: pw.Font.helvetica(),
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.TextSpan(
                  text: 'declare that:',
                  style: pw.TextStyle(
                    // fontBold: pw.Font.helvetica(),
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 5),

          _row('a.', declaration[0]),
          pw.SizedBox(height: 5),
          _row('b.', declaration[1]),
          pw.SizedBox(height: 5),

          _row('c.', declaration[2]),
          pw.SizedBox(height: 5),

          _row('d.', declaration[3]),
          // pw.Text('a. I am the duly authorised representative of the vendor supplying the commodity.'),
          // pw.Text('b. All the information in this document is true and correct;'),
          // pw.Text('c. I have read, understood and answered all questions in accordance with the explanatory notes.'),
          // pw.Text(
          //     'd. I understand that regulatory authorities may take legal action, and purchasers may seek damages if the information provided is false or misleading'),

          pw.SizedBox(height: 12),
          // Signature
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Signature:',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Container(
                decoration: const pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.all(
                    pw.Radius.circular(5),
                  ),
                ),
                width: 200,
                height: 100,
                child: pw.Image(
                  pw.MemoryImage(
                    base64Decode(signature),
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
        ],
      ),
    );
  }

  pw.Row _row(String point, String answer) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(point),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: pw.Text(
            answer,
            style: pw.TextStyle(
              // height: 1.5,
              font: pw.Font.times(),
            ),
          ),
        )
      ],
    );
  }
}
