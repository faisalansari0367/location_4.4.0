import 'package:background_location/ui/cvd_form/models/chemical_use.dart';
import 'package:background_location/ui/cvd_form/widgets/add_fields.dart';
import 'package:background_location/ui/cvd_form/widgets/common_buttons.dart';
import 'package:background_location/ui/cvd_form/widgets/cvd_textfield.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../constants/my_decoration.dart';
import '../cubit/cvd_cubit.dart';

class ChemicalUse extends StatefulWidget {
  final ChemicalUseDetailsModel chemicalUseDetailsModel;
  const ChemicalUse({Key? key, required this.chemicalUseDetailsModel}) : super(key: key);

  @override
  State<ChemicalUse> createState() => _ChemicalUseState();
}

class _ChemicalUseState extends State<ChemicalUse> {
  // ChemicalUseModel? form;
  ChemicalUseDetailsModel? form;
  final formData = {};
  List<Map> tableData = [];
  bool showTable = false;

  Future<void> _init() async {
    // final data = await DefaultAssetBundle.of(context).loadString('assets/json/chemical_use.json');
    // final map = jsonDecode(data);
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
    if (form == null) return const SizedBox();
    return SingleChildScrollView(
      child: AutoSpacing(
        children: [
          _QuestionWithCheckbox(
            // field: form?.chemicalCheck?.field ?? '',
            questionNo: '4',
            fieldData: form!.chemicalCheck!,
            // options: form!.chemicalCheck!.options!.map((e) => e.label!).toList(),
            // value: form!.chemicalCheck!.options!,
            // onChanged: (index) {
            //   final e = form!.chemicalCheck!.options![index];
            //   form?.chemicalCheck?.value = e.value;
            // },
          ),
          // if (showTable) _buildTable(),
          // ChemicalUseQuestion4(),
          _QuestionWithCheckbox(
            // // field: form?.qaCheck?.field ?? '',
            questionNo: '5',
            fieldData: form!.qaCheck!,
            // onChanged: (index) {
            //   final e = form!.qaCheck!.options![index];
            //   form?.qaCheck?.value = e.value;
            // },
          ),
          _QuestionWithCheckbox(
            // // field: form?.cvdCheck?.field ?? '',
            questionNo: '6',
            fieldData: form!.cvdCheck!,
            // onChanged: (index) {
            //   final e = form!.cvdCheck!.options![index];
            //   form?.cvdCheck?.value = e.value;
            // },
          ),
          AddFields(
            no: '7. ',
            field: form?.cropList?.field ?? '',
            onChanged: (list) {
              form?.cropList?.value = list.join();
            },
          ),
          _QuestionWithCheckbox(
            // // field: form?.riskCheck?.field ?? '',
            questionNo: '8',
            fieldData: form!.riskCheck!,
            // onChanged: (index) {
            //   final e = form!.riskCheck!.options![index];
            //   form?.riskCheck?.value = e.value;
            // },
          ),
          _QuestionWithCheckbox(
            // // field: form?.nataCheck?.field ?? '',
            questionNo: '9',
            fieldData: form!.nataCheck!,
            // onChanged: (index) {
            //   final e = form!.nataCheck!.options![index];
            //   form?.nataCheck?.value = e.value;
            // },
          ),
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
              // _form.forEach((key, value) {
              // });
              // if (formData.length < 5) {
              //   DialogService.error('Please answer all the questions');
              // } else {
              final cubit = context.read<CvdCubit>();
              //   formData['tableData'] = tableData;
              //   cubit.addFormData(formData);
              cubit.changeCurrent(cubit.state.currentStep, isNext: true);
              // }
            },
          ),
        ],
      ),
    );
  }

  // void _onChanged(Map<dynamic, dynamic> map) {
  //   formData.addAll(map);
  // if (formData.containsKey(form?.question4?.field)) {
  //   final value = formData[form?.question4?.field];
  //     if (value is Set) {
  //       if ((value.first as String).contains('Yes')) {
  //         showTable = true;
  //         setState(() {});
  //       } else {
  //         showTable = true;
  //         setState(() {});
  //       }
  //     }
  //   }
  // }
// }
}

class _QuestionWithCheckbox extends StatefulWidget {
  final String questionNo;
  // final Options? value;
  final FieldData fieldData;

  // // final ValueChanged<int>? onChanged;
  // // final List<Options> options;
  // final bool multipleSelection;
  const _QuestionWithCheckbox({
    Key? key,
    // required this.field,
    required this.questionNo,
    // required this.options,
    // this.multipleSelection = false,
    //   // this.onChanged,
    //   // this.value,
    required this.fieldData,
  }) : super(key: key);

  @override
  State<_QuestionWithCheckbox> createState() => _QuestionWithCheckboxState();
}

class _QuestionWithCheckboxState extends State<_QuestionWithCheckbox> {
  final formData = {};
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MyDecoration.decoration().copyWith(border: Border.all(color: Colors.grey.shade200)),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
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
                    // value: getValue(widget.field, e),
                    value: e.value == widget.fieldData.value,
                    onChanged: (s) {
                      // if (!widget.multipleSelection) {
                      // setValue(widget.field, e, canSelectOne: true);
                      // } else {
                      // setValue(widget.field, e);
                      // }
                      widget.fieldData.value = e.value;
                      //   // widget.onChanged?.call(e);
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
        ],
      ),
    );
  }

  // bool? getValue(String? field, String? id) {
  // final data = formData[field!];
  // if (data == null) return false;
  // if (data is int) return {data}.contains(id);
  // return (formData[field] as Set?)?.contains(id);
}

  // void setValue(String field, String id, {bool canSelectOne = false}) {
    // final dataSet = <String>{};
    // // final data = formData[field];
    // if (data == null) {
    //   dataSet.add(id);
    //   // formData[field] = dataSet;
    // } else {
    //   if (!canSelectOne) dataSet.addAll(data);
    //   dataSet.contains(id) ? dataSet.remove(id) : dataSet.add(id);
    //   // formData[field] = dataSet;
    // }
    // print(formData);
  // }
// }
