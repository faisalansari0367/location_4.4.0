import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/cvd_form/models/chemical_use.dart';
import 'package:background_location/ui/cvd_form/widgets/add_fields.dart';
import 'package:background_location/ui/cvd_form/widgets/add_table_entries.dart';
import 'package:background_location/ui/cvd_form/widgets/cvd_textfield.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:background_location/widgets/dialogs/dialog_layout.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

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
                    tableData.add(value);
                    widget.chemicalUseDetailsModel.chemicalTable = tableData;
                    setState(() {});
                  },
                ));
              }
            },
            children: [
              Table(
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
              // EditableTable(
              //     headers: ['Chemical Applied', 'Rate (Tonne/ Ha)', 'Application Date', 'WHP/ ESI/ EAFI'],

              //     onRowAdd: onRowAdd)
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
                _enterTextPopup((s) {
                  cubit.riskAssesment = s;
                  setState(() {});
                }, 'Enter Risk Assesment');
              }
            },
          ),
          _QuestionWithCheckbox(
            questionNo: '9',
            fieldData: form!.nataCheck!,
            onChanged: (s) {
              if (form!.nataCheck!.value == '1') {
                _enterTextPopup((s) {
                  cubit.testResults = s;
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
              for (var value in _form.values) {
                if (value is Map) {
                  if (value['value'] == null) {
                    DialogService.error('Please fill the ${value['field']}');
                    return;
                  }
                }
              }

              final cubit = context.read<CvdCubit>();

              // cubit.changeCurrent(cubit.state.currentStep, isNext: true);
              cubit.moveToNext();
            },
          ),
        ],
      ),
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
  Widget _dataCell(String text) {
    return Text(
      text,
      style: TextStyle(),
    );
  }

  void _enterTextPopup(ValueChanged<String> onChanged, String hint) {
    DialogService.showDialog(
      child: DialogLayout(
        child: Padding(
          padding: kPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: hint,
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
                minLines: 3,
                onChanged: onChanged,
              ),
              Gap(10.h),
              MyElevatedButton(
                text: 'Save',
                onPressed: () async {
                  Get.back();
                  setState(() {});
                },
              ),
            ],
          ),
        ),
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
