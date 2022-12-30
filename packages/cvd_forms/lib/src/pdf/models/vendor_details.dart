import 'package:pdf/widgets.dart' as pw;

import '../widgets/basic_pdf_widgets.dart';

class VendorDetails {
  final String name;
  final String address;
  final String town;
  final String email;
  final String tel;
  final String ngr;
  final String fax;
  final String pic;
  final String contractNo;

  VendorDetails({
    this.pic = '',
    this.contractNo = '',
    this.fax = '',
    this.name = '',
    this.address = '',
    this.town = '',
    this.email = '',
    this.tel = '',
    this.ngr = '',
  });

  pw.Widget vendorDetails() {
    return Widgets.drawBox(
      title: 'Vendor Details',
      child: Widgets.column(
        spacing: 5,
        children: [
          Widgets.richText('Name', name),
          Widgets.richText('Address', address),
          Widgets.richText('Town', town),
          Widgets.richText('Tel', tel),
          Widgets.richText('Fax', fax),
          Widgets.richText('Email', email),
          Widgets.richText('National Grower Registration (NGR) No', ngr),
          Widgets.richText('Property Identification Code (PIC)', pic),
          Widgets.richText('Vendors Contract/Reference No', contractNo),
        ],
      ),
    );
  }
}
