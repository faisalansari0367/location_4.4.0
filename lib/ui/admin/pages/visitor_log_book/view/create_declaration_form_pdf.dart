import 'dart:convert';

import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/services/notifications/forms_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DeclarationFormPrinter {
  final LogbookEntry entry;
  final FormsStorageService formsStorageService;
  const DeclarationFormPrinter(
      {required this.entry, required this.formsStorageService});

  Future<void> createPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              _buildHeader(),
              _userInfo(),
              pw.SizedBox(height: 30),
              pw.Expanded(
                child: form.isWarakirriFarm
                    ? _buildWarakirriForm()
                    : _buildDeclarationForm(),
              ),
              // form.isWarakirriFarm ? _buildWarakirriForm() : _buildDeclarationForm(),
              // _card(_warakirriKeys.isPeopleTravelingWith, form.getVisitorsNames()),
              // _card(_warakirriKeys.isFluSymptoms, form.getValue(form.isFluSymptoms)),
              // _card(_warakirriKeys.isOverSeaVisit, form.getValue(form.isOverSeaVisit)),
              // _card(_warakirriKeys.hasBeenInducted, form.getValue(form.hasBeenInducted)),
              // _card(_warakirriKeys.isConfinedSpace, form.getValue(form.isConfinedSpace)),
              // _card(_warakirriKeys.additionalInfo, form.additionalInfo),
              // _card(_warakirriKeys.warakirriFarm, form.warakirriFarm),
            ],
          );
        },
      ),
    );

    await _saveFile(await pdf.save());
  }

  pw.Column _buildWarakirriForm() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _card(_warakirriKeys.isPeopleTravelingWith, form.getVisitorsNames()),
        _card(_warakirriKeys.isFluSymptoms, form.getValue(form.isFluSymptoms)),
        _card(
            _warakirriKeys.isOverSeaVisit, form.getValue(form.isOverSeaVisit)),
        _card(_warakirriKeys.hasBeenInducted,
            form.getValue(form.hasBeenInducted)),
        _card(_warakirriKeys.isConfinedSpace,
            form.getValue(form.isConfinedSpace)),
        _card(_warakirriKeys.additionalInfo, form.additionalInfo),
        _card(_warakirriKeys.warakirriFarm, form.warakirriFarm),
      ],
    );
  }

  pw.Column _buildDeclarationForm() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _card(
          form.keys.isPeopleTravelingWith,
          (form.usersTravellingAlong?.isEmpty ?? true)
              ? 'No'
              : form.usersTravellingAlong!.join(', '),
        ),
        // if(form.isQfeverVaccinated != null)
        _card(form.keys.isQfeverVaccinated,
            form.getValue(form.isQfeverVaccinated!)),
        _card(form.keys.isFluSymptoms, form.getValue(form.isFluSymptoms)),
        _card(form.keys.isOverSeaVisit, form.getValue(form.isOverSeaVisit)),
        _card(
            form.keys.isAllMeasureTaken, form.getValue(form.isAllMeasureTaken)),
        _card(form.keys.isOwnerNotified, form.getValue(form.isOwnerNotified)),
        // _card(
        //   form.keys.expectedDepartureDate,
        //   MyDecoration.formatDateWithTime(form.expectedDepartureDate),
        // ),
        pw.Row(
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _card(form.keys.rego, form.rego),
                _card(form.keys.riskRating, form.riskRating),
              ],
            ),
            pw.Spacer(),
            if (form.signature != null)
              pw.Image(
                pw.MemoryImage(base64Decode(form.signature!)),
                height: 100,
                width: 100,
              ),
          ],
        ),
        // pw.SizedBox(height: 10.h),
        // if (form.signature != null)
        //   pw.Image(
        //     pw.MemoryImage(base64Decode(form.signature!)),
        //     height: 100,
        //     width: 100,
        //   ),
        pw.SizedBox(height: 20.h),
      ],
    );
  }

  Future<void> _saveFile(Uint8List bytes) async {
    final file =
        await formsStorageService.saveLogbookPdf(bytes: bytes, entry: entry);
    OpenFile.open(file.path);
  }

  LogbookFormModel get form => entry.form!;

  WarakirriQuestionFormModel get _warakirriKeys => entry.form!.warakirriKeys;

  pw.Container _card(String key, String? value2) {
    if (value2 == null) return pw.Container();
    return pw.Container(
      // padding: pw.EdgeInsets.all(20),
      margin: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            entry.form!.question(key),
            style: pw.TextStyle(
              color: PdfColors.black,
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
            ),
          ),
          pw.Text(
            value2,
            style: const pw.TextStyle(fontSize: 16, color: PdfColors.blue),
          ),
        ],
      ),
    );
  }

  pw.Container _buildHeader() {
    final data = entry;
    return pw.Container(
      decoration: const pw.BoxDecoration(),
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
    );
  }

  pw.Container _userInfo() {
    return pw.Container(
      // padding: kPadding,
      // margin: kPadding,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Entry Details',
            style: const pw.TextStyle(fontSize: 20),
          ),
          pw.SizedBox(height: 20.h),
          _buildRow('Full Name', entry.user?.fullName ?? '', 'Company Name',
              entry.user?.company ?? ''),
          pw.SizedBox(height: 20.h),
          _buildRow(
            'Phone Number',
            '${entry.user?.countryCode ?? ''} ${entry.user?.phoneNumber ?? ''}',
            'Expected Departure Time',
            MyDecoration.formatDateWithTime(form.expectedDepartureDate),
          )
        ],
      ),
    );
  }

  pw.Row _buildRow(String field1, String value1, String field2, String value2) {
    return pw.Row(
      children: [
        pw.Expanded(
          flex: 2,
          child: _buildText(field1, value1),
        ),
        pw.Spacer(),
        pw.Expanded(
          flex: 2,
          child: _buildText(field2, value2),
        ),
      ],
    );
  }

  pw.Column _buildText(String text, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          text,
          maxLines: 1,
          style: const pw.TextStyle(
            color: PdfColors.grey,
          ),
        ),
        pw.SizedBox(height: 5.h),
        pw.Text(
          value,
          maxLines: 2,
          style: pw.TextStyle(
            color: PdfColors.black,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
