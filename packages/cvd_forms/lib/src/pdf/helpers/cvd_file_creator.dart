// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
// import 'package:flutter_cvd_pdf/models/buyer_details.dart';
// import 'package:flutter_cvd_pdf/models/commodity_details.dart';
// import 'package:flutter_cvd_pdf/product_integrity/product_integrity.dart';
// import 'package:flutter_cvd_pdf/models/transporter_details.dart';
// import 'package:flutter_cvd_pdf/models/vendor_details.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/models.dart';
import '../widgets/basic_pdf_widgets.dart';

class CvdFileGenerator {
  final BuyerDetails buyerDetails;
  final VendorDetails vendorDetails;
  final CommodityDetails commodityDetails;
  final TransporterDetails transporterDetails;
  final ProductIntegrityPartA productIntegrityPartA;
  final ProductIntegrityPartB productIntegrityPartB;
  final ProductIntegrityPartC productIntegrityPartC;

  CvdFileGenerator({
    required this.buyerDetails,
    required this.vendorDetails,
    required this.commodityDetails,
    required this.transporterDetails,
    required this.productIntegrityPartA,
    required this.productIntegrityPartB,
    required this.productIntegrityPartC,
  });

  Future<Uint8List> generatePdf() async {
    return await _createDocument().save();
  }

  pw.Page _createPage({required pw.Widget child}) {
    return pw.Page(
      pageTheme: _pageTheme(),
      build: (context) => child,
    );
  }

  pw.PageTheme _pageTheme() {
    return pw.PageTheme(
      theme: pw.ThemeData.withFont(
        base: pw.Font.times(),
        bold: pw.Font.timesBold(),
        italic: pw.Font.timesItalic(),
        boldItalic: pw.Font.timesBoldItalic(),
      ),
    );
  }

  pw.Document _createDocument() {
    final pdf = pw.Document();

    pdf.addPage(
      _createPage(
        child: Widgets.column(
          children: [
            Widgets.pageTitle(),
            _page1(),
          ],
        ),
      ),
    );

    //
    pdf.addPage(_createPage(child: productIntegrityPartA.partAProductIntegrity()));
    pdf.addPage(_createPage(child: productIntegrityPartB.partBChemicalUse()));
    pdf.addPage(_createPage(child: productIntegrityPartB.q7To9()));
    pdf.addPage(_createPage(child: productIntegrityPartC.selfDeclaration()));
    return pdf;
  }

  pw.Column _page1() {
    return Widgets.column(
      children: [
        Widgets.row(
          children: [
            pw.Expanded(child: vendorDetails.vendorDetails()),
            pw.SizedBox(width: 20),
            pw.Expanded(child: buyerDetails.buyerDetails()),
          ],
        ),
        pw.SizedBox(height: 20),
        Widgets.row(
          children: [
            pw.Expanded(child: transporterDetails.transporterDetails()),
            pw.SizedBox(width: 20),
            pw.Expanded(child: commodityDetails.commodityDetails()),
          ],
        ),
        pw.SizedBox(height: 20),
        // _partAProductIntegrity(),
      ],
    );
  }
}
