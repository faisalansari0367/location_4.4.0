import 'package:pdf/widgets.dart' as pw;

import '../widgets/basic_pdf_widgets.dart';

class TransporterDetails {
  final String name;
  final String email;
  final String tel;
  final String company;
  final String registration;

  TransporterDetails({
    this.name = '',
    this.email = '',
    this.tel = '',
    this.company = '',
    this.registration = '',
  });

  pw.Widget transporterDetails() {
    return Widgets.drawBox(
      title: 'Transporter Details',
      child: Widgets.column(
        spacing: 5,
        children: [
          Widgets.richText('Driver Name', 'John Doe'),
          Widgets.richText('Email-Id', '42'),
          Widgets.richText('Transporter Contact No', '123 Main Street'),
          Widgets.richText('Company', '123 Main Street'),
          Widgets.richText('Registration', '123 Main Street'),
        ],
      ),
    );
  }
}
