// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:pdf/widgets.dart' as pw;

import '../../widgets/basic_pdf_widgets.dart';

class ProductIntegrityPartA {
  ProductIntegrityPartA({
    required this.sourceCheck,
    required this.materialCheck,
    required this.gmoCheck,
  });

  final int sourceCheck;
  final int materialCheck;
  final int gmoCheck;

  pw.Widget partAProductIntegrity() {
    final comoodityOptions = [
      'Single Source, Single Storage (eg off the header)',
      'Multi-Vendor Storage (eg grain depot, cotton, gin seed storage)',
      'Single Source, Comingled Storage (eg farm silo)',
      'Factory Developed Product (eg ethonol plant, gluten plant)',
    ];

    final gmoOptions = [
      'Is non GMO as defined by 99% non GMO',
      'Contains greater than 5% GMO or content unknown',
      'Is non GMO as defined by 95% non GMO',
    ];

    final containMaterial = ['Yes', 'No'];

    return Widgets.drawBox(
      title: 'Part A: Product Integrity',
      child: Widgets.column(
        children: [
          _mcq(
            qNo: '1',
            question: 'Commodity Source (Tick One):',
            options:
                comoodityOptions.map((e) => _checkBoxOption(name: e, value: e == comoodityOptions[gmoCheck])).toList(),
          ),
          pw.SizedBox(height: 10),

          _mcq(
            qNo: '2',
            question: 'Does This Commodity Contain Restricted Animal Materials (eg Meat and Bone Meal)?',
            options: containMaterial
                .map((e) => _checkBoxOption(name: e, value: e == containMaterial[materialCheck]))
                .toList(),
          ),
          pw.SizedBox(height: 10),

          _mcq(
            qNo: '3',
            question: 'With Respect to Genetically Modified Organisms, This Commodity: (Tick One)',
            options: gmoOptions.map((e) => _checkBoxOption(name: e, value: e == gmoOptions[sourceCheck])).toList(),
          ),
          // pw.SizedBox(height: 5),
        ],
      ),
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
