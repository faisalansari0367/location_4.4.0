import 'package:bioplus/constants/index.dart';
import 'package:bioplus/helpers/validator.dart';
import 'package:bioplus/ui/cvd_form/widgets/add_fields.dart';
import 'package:bioplus/ui/cvd_form/widgets/add_table_entries.dart';
import 'package:bioplus/ui/cvd_form/widgets/cvd_textfield.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:bioplus/widgets/dialogs/dialog_layout.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:cvd_forms/models/src/chemical_use.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/cvd_cubit.dart';
import 'common_buttons.dart';

class ChemicalUse extends StatefulWidget {
  final ChemicalUseDetailsModel chemicalUseDetailsModel;
  const ChemicalUse({Key? key, required this.chemicalUseDetailsModel}) : super(key: key);

  @override
  State<ChemicalUse> createState() => _ChemicalUseState();
}

class _ChemicalUseState extends State<ChemicalUse> {
  ChemicalUseDetailsModel? form;
  final formData = {};
  List<ChemicalTable> tableData = [];
  bool showTable = false;
  // String riskAssesment = '';
  // String testResults = '';

  Future<void> _init() async {
    form = widget.chemicalUseDetailsModel;
    tableData = widget.chemicalUseDetailsModel.chemicalTable;
    // form?.cropList?
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CvdCubit>();
    if (form == null) return const SizedBox();
    return SingleChildScrollView(
      child: AutoSpacing(
        children: [
          Text(
            'Part B - Chemical Use',
            style: context.textTheme.headline6?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          _QuestionWithCheckbox(
            questionNo: '4',
            fieldData: form!.chemicalCheck!,
            onChanged: (v) {
              if (v ?? false) {
                BottomSheetService.showSheet(child: AddTableEntries(
                  onChanged: (value) {
                    // tableData.add(value);
                    tableData.insert(0, value);
                    widget.chemicalUseDetailsModel.chemicalTable = tableData;
                    setState(() {});
                  },
                ));
              }
            },
            children: [
              // _table(),
              SingleChildScrollView(
                child: _dataTable(),
                scrollDirection: Axis.horizontal,
              ),
              Gap(10.h),
              ElevatedButton(
                onPressed: () {
                  BottomSheetService.showSheet(child: AddTableEntries(
                    onChanged: (value) {
                      tableData.add(value);
                      setState(() {});
                    },
                  ));
                },
                child: Text(
                  'Add Another Product',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
            height: 2,
          ),
          _QuestionWithCheckbox(
            questionNo: '5',
            fieldData: form!.qaCheck!,
            onChanged: (s) {},
            children: [
              Gap(20.h),
              CvdTextField(
                name: form!.qaProgram!.field!,
                value: form!.qaProgram?.value,
                onChanged: (s) {
                  form?.qaProgram?.value = s;
                },
              ),
              CvdTextField(
                name: form!.certificateNumber!.field!,
                value: form!.certificateNumber?.value,
                onChanged: (s) {
                  form?.certificateNumber?.value = s;
                },
              ),
            ],
          ),
          _QuestionWithCheckbox(
            questionNo: '6',
            fieldData: form!.cvdCheck!,
          ),
          AddFields(
            no: '7. ',
            value: form?.cropList?.value,
            field: form?.cropList?.field ?? '',
            onChanged: (list) {
              form?.cropList?.value = list.join();
            },
          ),
          _QuestionWithCheckbox(
            questionNo: '8',
            fieldData: form!.riskCheck!,
            children: [
              Divider(),
              _resultsBox(context, 'Risk Assesment Results', cubit.riskAssesment),
            ],
            onChanged: (value) {
              if (form!.riskCheck!.value == '1') {
                _enterTextPopup(
                  (s) {
                    cubit.setRiskAssesment(s);
                    setState(() {});
                  },
                  'Enter Risk Assesment',
                );
              }
            },
          ),
          _QuestionWithCheckbox(
            questionNo: '9',
            fieldData: form!.nataCheck!,
            onChanged: (s) {
              if (form!.nataCheck!.value == '1') {
                _enterTextPopup((s) {
                  // cubit.testResults = s;
                  cubit.setTestResults(s);
                  setState(() {});
                }, 'Enter Test Results');
              }
            },
            children: [
              Divider(),
              _resultsBox(context, 'Test Results', cubit.testResults),
            ],
          ),
          CommonButtons(
            onContinue: () {
              final _form = form!.toJson();

              final cubit = context.read<CvdCubit>();
              for (var value in _form.values) {
                if (value is Map) {
                  // value['key']
                  print(value['value']);
                  if (value['value'] == null) {
                    DialogService.error('Please fill the ${value['field']}');
                    return;
                  }
                  if ([form!.cropList?.key, form!.qaProgram?.key, form!.certificateNumber?.key]
                      .contains(value['key'])) {
                    cubit.moveToNext();
                    return;
                  }
                }
              }

              // cubit.changeCurrent(cubit.state.currentStep, isNext: true);
              cubit.moveToNext();
            },
          ),
        ],
      ),
    );
  }

  Table _table() {
    return Table(
      border: TableBorder.all(style: BorderStyle.solid, color: Colors.grey.shade400),
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        TableRow(
          children: [
            Text('Chemical Applied'),
            Text('Rate (Tonne/ Ha)'),
            Text('Application Date'),
            Text('WHP/ ESI/ EAFI'),
          ],
        ),
        ...tableData.map(
          (e) => TableRow(
            children: [
              Text(e.chemicalName ?? ''),
              Text(e.rate ?? ''),
              Text(MyDecoration.formatDate(DateTime.tryParse(e.applicationDate!))),
              Text(e.wHP ?? ''),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dataTable() {
    // tableData.sort(_sortByDate);
    return DataTable(
      // dataRowHeight: 10.height,
      columns: [
        _column('Chemical Applied'),
        _column('Rate'),
        _column('Application Date'),
        _column('WHP/ ESI/ EAFI'),
        _column(''),
      ],
      rows: tableData.map((e) => _row(e)).toList(),
    );
  }

  int _sortByDate(ChemicalTable a, ChemicalTable b) {
    final _a = DateTime.tryParse(a.applicationDate!);
    final _b = DateTime.tryParse(b.applicationDate!);

    return _a!.compareTo(_b!);
  }

  DataColumn _column(String text) {
    return DataColumn(
      label: SizedBox(
        // width: 25.width,
        child: Text(
          text,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  DataRow _row(ChemicalTable e) {
    return DataRow(
      cells: <DataCell>[
        DataCell(
          Text(e.chemicalName ?? ''),
          // placeholder: true,
        ),
        DataCell(
          Text(e.rate ?? ''),
        ),
        DataCell(Text(e.applicationDate ?? '')),
        DataCell(Text(e.wHP ?? '')),
        DataCell(
          IconButton(
            color: Colors.red,
            icon: Icon(Icons.delete),
            onPressed: () {
              tableData.remove(e);
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Container _resultsBox(BuildContext context, String text, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: MyDecoration.decoration(shadow: false).copyWith(border: Border.all()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  // datarow

  void _enterTextPopup(ValueChanged<String> onChanged, String hint) {
    DialogService.showDialog(
      child: DialogLayout(
        child: _EnterResults(hint: hint, onSave: onChanged),
      ),
    );
  }
}

class _QuestionWithCheckbox extends StatefulWidget {
  final String questionNo;

  final FieldData fieldData;
  final ValueChanged<bool?>? onChanged;
  final List<Widget> children;

  const _QuestionWithCheckbox({
    Key? key,
    required this.questionNo,
    required this.fieldData,
    this.onChanged,
    this.children = const [],
  }) : super(key: key);

  @override
  State<_QuestionWithCheckbox> createState() => _QuestionWithCheckboxState();
}

class _QuestionWithCheckboxState extends State<_QuestionWithCheckbox> {
  final formData = {};
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.questionNo}. ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.w,
                ),
              ),
              Expanded(
                child: Text(
                  widget.fieldData.field!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.w,
                  ),
                ),
              ),
            ],
          ),
          Gap(10.h),
          ...widget.fieldData.options!
              .map(
                (e) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: e.value == widget.fieldData.value,
                    onChanged: (s) {
                      widget.fieldData.value = e.value;
                      widget.onChanged?.call(e.value == '1');
                      setState(() {});
                    },
                    title: Text(
                      e.label!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          if (widget.fieldData.value == '1') ...widget.children,
        ],
      ),
    );
  }
}

class _EnterResults extends StatefulWidget {
  final String hint;
  final ValueChanged<String> onSave;

  const _EnterResults({required this.hint, required this.onSave});

  @override
  State<_EnterResults> createState() => _EnterResultsState();
}

class _EnterResultsState extends State<_EnterResults> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kPadding,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: widget.hint,
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
              minLines: 3,
              validator: Validator.text,
              controller: _controller,
            ),
            Gap(10.h),
            MyElevatedButton(
              text: 'Save',
              onPressed: _onSave,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_controller.text);
      Get.back();
    }
  }
}
