// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pdf/widgets.dart' as pw;

import '../../../../models/src/chemical_use.dart';
import '../../widgets/basic_pdf_widgets.dart';

class ProductIntegrityPartB {
  ProductIntegrityPartB({
    required this.chemicalCheck,
    required this.qaCheck,
    required this.cvdCheck,
    required this.materialCheck,
    required this.nataCheck,
    required this.riskCheck,
    required this.qaName,
    required this.certificateNumber,
    required this.riskAssesment,
    required this.testResults,
    required this.chemicals,
    required this.cropList,
  });

  final int chemicalCheck;
  final int qaCheck;
  final int cvdCheck;
  final int materialCheck;
  final int nataCheck;
  final int riskCheck;
  final String qaName;
  final String certificateNumber;
  final String riskAssesment;
  final String testResults;
  final List<ChemicalTable> chemicals;
  final List<String> cropList;

  pw.Widget partBChemicalUse() {
    return Widgets.drawBox(
      title: 'Part B - Chemical Use',
      child: Widgets.column(
        children: [
          _mcq(
            qNo: '4',
            question:
                'Is This Commodity within a withholding period(WHP), export slauther interval(ESI) or export Animal feed interval(EAFI) following treatment with any plant chemical including a pickling or seed treatment, fumigant, pesticide or insecticide:',
            options: ['No', 'Yes, enter details in the table below']
                .map((e) => _checkBoxOption(
                    name: e, value: e == ['No', 'Yes, enter details in the table below'][chemicalCheck]))
                .toList(),
          ),
          chemicalCheck == 1 ? _buildTable() : pw.SizedBox(),
          _mcq(
            qNo: '5',
            question:
                'has the commodity been grown and/ or stored under an independent audited QA program which includes chemical residue management?',
            options: ['No', 'Yes, provider details'].map((e) => _checkBoxOption(name: e, value: e == 'No')).toList(),
          ),
          qaCheck == 1 ? _buildQAcheck() : pw.SizedBox(),
          _mcq(
            qNo: '6',
            question:
                'Is the vendor of this commodity currently aware of its full chemical treatment history or holds a CVD containing this history?',
            options: ['No', 'Yes'].map((e) => _checkBoxOption(name: e, value: e == 'No')).toList(),
          ),
          // _mcq(
          //   qNo: '7',
          //   question:
          //       'List all known adjacent crops grown within 100 metres of this commodity (only applicable for single source commodities',
          //   options: ['No', 'Yes'].map((e) => _checkBoxOption(name: e, value: e == 'No')).toList(),
          // ),
          // cropList.isNotEmpty ? _buildCropList() : pw.SizedBox(),
          // _mcq(
          //   qNo: '8',
          //   question: 'If the commodity is a by-product, has a risk assessment been completed? (tick one)',
          //   options: ['No', 'Yes', 'N/A'].map((e) => _checkBoxOption(name: e, value: e == 'No')).toList(),
          // ),
          // if (riskCheck == 1) pw.Text(riskAssesment),
          // _mcq(
          //   qNo: '9',
          //   question:
          //       'Has the commodity been analysed for chemical residues or toxins by a lab accredited by NATA for the specific test required?',
          //   options: ['Yes', 'No'].map((e) => _checkBoxOption(name: e, value: e == 'No')).toList(),
          // ),
          // if (nataCheck == 1) pw.Text(testResults),
        ],
      ),
    );
  }

  pw.Widget buildQuestionNo4() {
    final column = Widgets.column(children: [
      _mcq(
        qNo: '4',
        question:
            'Is This Commodity within a withholding period(WHP), export slauther interval(ESI) or export Animal feed interval(EAFI) following treatment with any plant chemical including a pickling or seed treatment, fumigant, pesticide or insecticide:',
        options: ['No', 'Yes, enter details in the table below']
            .map((e) =>
                _checkBoxOption(name: e, value: e == ['No', 'Yes, enter details in the table below'][chemicalCheck]))
            .toList(),
      ),
      chemicalCheck == 1 ? _buildTable() : pw.SizedBox(),
    ]);

    return Widgets.drawBox(
      title: 'Part B - Chemical Use',
      child: column,
    );
  }

  pw.Column _buildQAcheck() {
    return Widgets.column(
      children: [
        pw.SizedBox(height: 5),
        Widgets.buildResults(
          ('QA Provider Name:'),
          qaName,
        ),
        pw.SizedBox(height: 5),
        Widgets.buildResults(
          ('Certificate Number:'),
          (certificateNumber),
        ),
        pw.SizedBox(height: 5),
      ],
    );
  }

  pw.Widget q7To9() {
    return Widgets.drawBox(
      title: 'Part B - Chemical Use',
      child: Widgets.column(
        children: [
          _mcq(
            qNo: '7',
            question:
                'List all known adjacent crops grown within 100 metres of this commodity (only applicable for single source commodities',
            options: ['No', 'Yes']
                .map((e) => _checkBoxOption(name: e, value: cropList.isNotEmpty ? e == 'Yes' : e == 'No'))
                .toList(),
          ),
          cropList.isNotEmpty ? _buildCropList() : pw.SizedBox(),
          _mcq(
            qNo: '8',
            question: 'If the commodity is a by-product, has a risk assessment been completed? (tick one)',
            options: ['No', 'Yes', 'N/A']
                .map((e) => _checkBoxOption(name: e, value: e == ['No', 'Yes', 'N/A'][riskCheck]))
                .toList(),
          ),
          if (riskCheck == 1) _buildResults('Risk Assessment', riskAssesment),
          _mcq(
            qNo: '9',
            question:
                'Has the commodity been analysed for chemical residues or toxins by a lab accredited by NATA for the specific test required?',
            options: ['Yes', 'No'].map((e) => _checkBoxOption(name: e, value: e == ['Yes', 'No'][nataCheck])).toList(),
          ),
          if (nataCheck == 0) _buildResults('Test Results', testResults),
        ],
      ),
    );
  }

  pw.Widget _buildResults(String key, String results) {
    return Widgets.column(
      children: [
        pw.SizedBox(height: 5),
        Widgets.drawContainer(
          child: Widgets.row(
            children: [
              pw.Text(
                '$key :',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Text(results),
              )
            ],
          ),
        ),
        pw.SizedBox(height: 5),
      ],
    );
  }

  pw.Widget _buildCropList() {
    final List<pw.TableRow> crops = [];
    for (var i = 0; i < cropList.length; i++) {
      final element = cropList[i];
      crops.add(
        pw.TableRow(
          children: [
            Widgets.tableCell((i + 1).toString()),
            Widgets.tableCell(element),
          ],
        ),
      );
    }

    final table = pw.Table(
      border: pw.TableBorder.all(),
      children: [
        Widgets.tableHeader(['', 'Crop Name']),
        ...crops,
      ],
    );
    // return table;
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 10.0),
      child: table,
    );
  }

  pw.Widget _buildTable() {
    final headers = ['Chemical Applied', 'Rate(Tonne/Hal)', 'Application Date', 'WHP/ESI/EAFI'];
    final table = pw.Table(
      border: pw.TableBorder.all(),
      // columnWidths: {
      //   0: const pw.FlexColumnWidth(2),
      //   1: const pw.FlexColumnWidth(1),
      //   2: const pw.FlexColumnWidth(1),
      //   3: const pw.FlexColumnWidth(1),
      // },
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        Widgets.tableHeader(headers),
        ...chemicals.map(
          (e) => pw.TableRow(
            children: [
              Widgets.tableCell(e.chemicalName ?? ''),
              Widgets.tableCell(e.rate ?? ''),
              Widgets.tableCell(e.applicationDate ?? ''),
              Widgets.tableCell(e.wHP ?? ''),
            ],
          ),
        ),
      ],
    );

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 10),
      child: table,
    );
  }

  pw.Widget _mcq({required String qNo, required String question, required List<pw.Widget> options}) {
    return Widgets.mcq(
      qNo: qNo,
      question: question,
      options: options,
    );
  }

  pw.Widget _checkBoxOption({required String name, required bool value}) {
    return Widgets.checkBoxOption(
      name: name,
      value: value,
    );
  }
}
