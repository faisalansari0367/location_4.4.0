import 'package:pdf/widgets.dart' as pw;

import '../widgets/basic_pdf_widgets.dart';

class CommodityDetails {
  final String commodity;
  final String variety;
  final String variety2;
  final String delivery;
  final int quantity;
  final int quantity2;
  final String totalQuantity;

  CommodityDetails({
    required this.commodity,
    required this.variety,
    required this.variety2,
    required this.delivery,
    required this.quantity,
    required this.quantity2,
    required this.totalQuantity,
  });

  pw.Widget commodityDetails() {
    return Widgets.drawBox(
      title: 'Commodity Details',
      child: Widgets.column(
        spacing: 5,
        children: [
          Widgets.richText('Commodity', commodity),
          Widgets.richText('Variety', variety),
          Widgets.richText('Variety', variety2),
          Widgets.richText('Delivery', delivery),
          Widgets.richText('Quantity', quantity.toString()),
          Widgets.richText('Quantity', quantity2.toString()),
          Widgets.richText('Total Quantity', totalQuantity),
        ],
      ),
    );
  }
}
