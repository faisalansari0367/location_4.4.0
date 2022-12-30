import 'package:pdf/widgets.dart' as pw;

import '../widgets/basic_pdf_widgets.dart';

class BuyerDetails {
  final String name;
  final String address;
  final String town;
  final String email;
  final String tel;
  final String ngr;
  final String fax;
  final String pic;
  final String refrence;

  BuyerDetails({
    this.refrence = '',
    this.name = '',
    this.address = '',
    this.town = '',
    this.email = '',
    this.tel = '',
    this.ngr = '',
    this.fax = '',
    this.pic = '',
  });

  pw.Widget buyerDetails() {
    return Widgets.drawBox(
      title: 'Buyer Details',
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
          Widgets.richText('Buyers Contract/Reference No', refrence),
        ],
      ),
    );
  }
}
