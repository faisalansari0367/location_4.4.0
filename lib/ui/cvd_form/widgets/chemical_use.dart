import 'dart:convert';

import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/cvd_form/models/chemical_use_model.dart';
import 'package:background_location/ui/cvd_form/widgets/add_fields.dart';
import 'package:background_location/ui/cvd_form/widgets/common_buttons.dart';
import 'package:background_location/ui/cvd_form/widgets/editable_table.dart';
import 'package:background_location/ui/cvd_form/widgets/question_with_checkbox.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cvd_cubit.dart';

class ChemicalUse extends StatefulWidget {
  const ChemicalUse({Key? key}) : super(key: key);

  @override
  State<ChemicalUse> createState() => _ChemicalUseState();
}

class _ChemicalUseState extends State<ChemicalUse> {
  ChemicalUseModel? form;
  final formData = {};
  List<Map> tableData = [];
  bool showTable = false;

  Future<void> _init() async {
    final data = await DefaultAssetBundle.of(context).loadString('assets/json/chemical_use.json');
    final map = jsonDecode(data);
    form = ChemicalUseModel.fromJson(map);
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (form == null) return const SizedBox();
    return SingleChildScrollView(
      child: Column(
        children: [
          QuestionWithCheckbox(
            field: form?.question4?.field ?? '',
            questionNo: '4',
            options: form?.question4?.options ?? [],
            onChanged: _onChanged,
          ),
          if (showTable) _buildTable(),
          QuestionWithCheckbox(
            field: form?.question5?.field ?? '',
            questionNo: '5',
            options: form?.question5?.options ?? [],
            onChanged: _onChanged,
          ),
          QuestionWithCheckbox(
            field: form?.question6?.field ?? '',
            questionNo: '6',
            options: form?.question6?.options ?? [],
            onChanged: _onChanged,
          ),
          AddFields(
            no: '7. ',
            field: form?.question7?.field ?? '',
          ),
          QuestionWithCheckbox(
            field: form?.question8?.field ?? '',
            questionNo: '8',
            options: form?.question8?.options ?? [],
            onChanged: _onChanged,
          ),
          QuestionWithCheckbox(
            field: form?.question9?.field ?? '',
            questionNo: '9',
            options: form?.question9?.options ?? [],
            onChanged: _onChanged,
          ),
          CommonButtons(onContinue: () {
            if (formData.length < 5) {
              DialogService.error('Please answer all the questions');
            } else {
              final cubit = context.read<CvdCubit>();
              formData['tableData'] = tableData;
              cubit.addFormData(formData);
              cubit.changeCurrent(0, isNext: true);
            }
          },),
        ],
      ),
    );
  }

  void _onChanged(Map<dynamic, dynamic> map) {
    formData.addAll(map);
    if (formData.containsKey(form?.question4?.field)) {
      final value = formData[form?.question4?.field];
      if (value is Set) {
        if ((value.first as String).contains('Yes')) {
          showTable = true;
          setState(() {});
        }
      }
    }
  }

  Container _buildTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: kBorderRadius,
      ),
      height: 30.height,
      child: EditableTable(
        onRowAdd: (value) {
          tableData = value;
        },
        headers: form?.question4!.tableHeader,
      ),
    );
  }
}
