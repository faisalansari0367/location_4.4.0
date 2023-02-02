// import 'dart:developer';
// import 'dart:io';
// import 'dart:ui';

// import 'package:open_file_safe/open_file_safe.dart';
// import 'package:path_provider/path_provider.dart';

// class SyncfusionPdf {
//   Future<void> createPdf(List<String> headers, List<List<String>> rows) async {
//     //Create a new PDF documentation
//     PdfDocument document = PdfDocument();

// //Create a PdfGrid
//     PdfGrid grid = PdfGrid();

// //Add the columns to the grid
//     grid.columns.add(count: headers.length);
//     grid.headers.add(1);

//     _createHeaders(headers, grid);

//     // PdfGridRow header = grid.headers[0];
//     // header.cells[0].value = 'Name';
//     // header.cells[1].value = 'Age';
//     // header.cells[2].value = 'Sex';

// //Add rows to grid. Set the cells style
//     _createRows(rows, grid);
//     // PdfGridRow row1 = grid.rows.add();
//     // row1.cells[0].value = 'Bob';
//     // row1.cells[1].value = '22';
//     // row1.cells[2].value = 'Male';
//     // PdfGridRow row2 = grid.rows.add();
//     // row2.cells[0].value = 'Sam';
//     // row2.cells[1].value = '23';
//     // row2.cells[2].value = 'Male';
//     // PdfGridRow row3 = grid.rows.add();
//     // row3.cells[0].value = 'Falitha';
//     // row3.cells[1].value = '19';
//     // row3.cells[2].value = 'Female';

// //Create a PdfLayoutFormat for pagination
//     PdfLayoutFormat format =
//         PdfLayoutFormat(breakType: PdfLayoutBreakType.fitColumnsToPage, layoutType: PdfLayoutType.paginate);

// //Draw the grid in PDF document page
//     grid.draw(page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0), format: format);

// //Save and dispose the PDF document
//     // File('SampleOutput.pdf').writeAsBytes(await document.save());
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final file = File('${directory.path}/${DateTime.now().millisecondsSinceEpoch}.pdf');
//       await file.writeAsBytes(await document.save());
//       await OpenFile.open(file.path);
//       // document.dispose();
//     } catch (e) {
//       log(e.toString());
//     }
//   }

//   PdfGridRow _createHeaders(List<String> headers, PdfGrid grid) {
//     PdfGridRow header = grid.headers[0];
//     for (int i = 0; i < headers.length; i++) {
//       header.cells[i].value = headers[i];
//     }
//     return header;
//   }

//   // create rows
//   void _createRows(List<List<String>> rows, PdfGrid grid) {
//     for (int i = 0; i < rows.length; i++) {
//       PdfGridRow row = grid.rows.add();
//       for (int j = 0; j < rows[i].length; j++) {
//         row.cells[j].value = rows[i][j];
//       }
//     }
//   }
// }
