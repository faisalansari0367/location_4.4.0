// import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart';

class Widgets {
  static final primaryColor = pdf.PdfColor.fromHex('#6873F6');

  static Column column({required List<Widget> children, double spacing = 0}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: autoSpacer(children, space: spacing),
    );
  }

  static Widget richText(String key, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: pdf.PdfColors.black),
        children: <TextSpan>[
          TextSpan(
            text: '$key: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontBold: Font.helvetica(),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  static Widget drawContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: primaryColor,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: child,
    );
  }

  static Widget drawBox({required Widget child, required String title}) {
    return drawContainer(
      child: column(
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  static Row row({required List<Widget> children}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  static Widget mcq({required String qNo, required String question, required List<Widget> options}) {
    return column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$qNo. ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: pdf.PdfColors.black,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                question,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: pdf.PdfColors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        // Text(
        //   '$qNo. $question:',
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     color: pdf.PdfColors.black,
        //     // fontSize: 18,
        //   ),
        // ),
        SizedBox(height: 10),
        ...autoSpacer(options, space: 5),
      ],
    );
  }

  static Widget checkBoxOption({required String name, bool value = false}) {
    final decoration = BoxDecoration(
      border: Border.all(color: pdf.PdfColors.black, width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(2)),
    );

    // final checked = File('assets/approved.png').readAsBytesSync();
    // final unchecked = File('assets/unchecked.png').readAsBytesSync();

    final checkbox = row(
      children: [
        Container(
          // margin: const EdgeInsets.all(1),
          // decoration: BoxDecoration(
          //   // color: PdfColors.white,
          //   color: pdf.PdfColors.black,

          //   border: Border.all(color: pdf.PdfColors.black, width: 2),
          //   borderRadius: const BorderRadius.all(Radius.circular(2)),
          // ),
          child: Checkbox(
            value: value,
            name: name,
            checkColor: pdf.PdfColors.black,
            activeColor: pdf.PdfColors.white,
            decoration: decoration,
          ),
        ),
        // Container(
        //   width: 10,
        //   height: 10,
        //   decoration: decoration,
        //   child: Container(
        //     decoration: const BoxDecoration(
        //       color: pdf.PdfColors.white,
        //       borderRadius: BorderRadius.all(Radius.circular(2)),
        //     ),
        //     child: Icon(
        //       const IconData(0xe156),
        //       color: pdf.PdfColors.white,
        //     ),
        //   ),
        // ),
        SizedBox(width: 10),
        Text(name),
      ],
    );

    return Padding(
      child: checkbox,
      padding: const EdgeInsets.only(left: 15),
    );
  }

  // static Widget table({required List<String> headers, required List<Widget> rows}) {
  //   final border = TableBorder.all();
  //   return Table(
  //     border: border,
  //     children: [
  //       TableRow(
  //         decoration: const BoxDecoration(color: primaryColor),
  //         children: [
  //           ...headers
  //               .map((e) => _tableContainer(Text(e, style: const TextStyle(color: pdf.PdfColors.white))))
  //               .toList(),
  //         ],
  //       ),
  //           // ...rows,
  //     ],
  //   );
  // }

  // static Widget _tableContainer(Widget child) {
  //   return Container(
  //     alignment: Alignment.center,
  //     child: child,
  //   );
  // }

  static Container tableHeaderCell(String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: pdf.PdfColors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget tableCell(String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }

  static TableRow tableHeader(List<String> headers) {
    return TableRow(
      decoration: BoxDecoration(color: primaryColor),
      children: headers.map((e) => tableHeaderCell(e)).toList(),
    );
  }

  static List<Widget> autoSpacer(List<Widget> children, {double space = 5}) {
    if (space == 0) return children;
    final List<Widget> result = [];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i != children.length - 1) {
        result.add(SizedBox(height: space));
      }
    }
    return result;
  }

  static Widget pageTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      alignment: Alignment.center,
      child: Center(
        child: Text(
          'Commodity Vendor Declaration',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryColor,
            fontSize: 28,
          ),
        ),
      ),
    );

    // return Header(
    //   // title: 'Commodity Vendor Declaration',
    //   text: 'Commodity Vendor Declaration',
    //   padding: const EdgeInsets.all(10),
    //   outlineColor: pdf.PdfColors.black,
    //   textStyle: TextStyle(
    //     fontWeight: FontWeight.bold,
    //     color: primaryColor,
    //     fontSize: 26,
    //   ),
    //   // decoration: const BoxDecoration(
    //   //   // color: primaryColor,
    //   // ),
    // );
  }

  static Widget buildResults(String key, String results) {
    return Widgets.column(
      children: [
        SizedBox(height: 5),
        Widgets.drawContainer(
          child: Widgets.row(
            children: [
              Text(
                '$key :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(results),
              )
            ],
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
