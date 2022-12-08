import 'dart:async';
import 'dart:convert';

import 'package:bioplus/constants/index.dart';
import 'package:bioplus/helpers/validator.dart';
import 'package:bioplus/ui/cvd_form/models/chemical_use.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/witholding_period_model.dart';

class AddTableEntries extends StatefulWidget {
  final ValueChanged<ChemicalTable>? onChanged;
  const AddTableEntries({Key? key, this.onChanged}) : super(key: key);

  @override
  State<AddTableEntries> createState() => _AddTableEntriesState();
}

class _AddTableEntriesState extends State<AddTableEntries> {
  var list = <WitholdingPeriodModel>[];
  WitholdingPeriodModel? selected;
  final formKey = GlobalKey<FormState>();
  final productName = TextEditingController();
  final whpDays = TextEditingController();
  final rateController = TextEditingController();
  final applicationDate = TextEditingController(text: DateTime.now().toIso8601String());
  late TextEditingController unitController = TextEditingController();

  @override
  void initState() {
    _readTable();
    super.initState();
  }

  void _readTable() async {
    final data = await rootBundle.loadString("assets/json/witholding_periods.json");
    final json = jsonDecode(data);
    // final list = <WitholdingPeriodsModel>[];
    for (var item in json) {
      final _data = WitholdingPeriodModel.fromJson(item);
      list.add(_data);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Autocomplete<WitholdingPeriodModel>(
            optionsBuilder: optionsBuilder,
            optionsViewBuilder: _optionsViewBuilder,
            fieldViewBuilder: _fieldViewBuilder,
            displayStringForOption: _displayStringForOption,
            onSelected: _onSelected,
          ),
          Gap(20.h),
          MyTextField(
            hintText: 'Chemical Applied',
            controller: productName,
            decoration: InputDecoration(
              labelText: ('Chemical Applied'),
            ),
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: MyTextField(
                  // hintText: 'Rate (Tonne/ Ha)',
                  controller: rateController,
                  textInputType: TextInputType.number,
                  validator: Validator.none,

                  decoration: InputDecoration(
                    labelText: 'Rate',
                  ),
                ),
              ),
              Gap(20.w),
              Expanded(
                child: MyTextField(
                  // hintText: 'Rate (Tonne/ Ha)',
                  // controller: rateController,
                  // textInputType: TextInputType.number,
                  onChanged: (s) {},
                  controller: unitController,
                  // value: '',
                  // options: ['ml', 'g/kg', 'g/l', 'g'],
                  validator: Validator.none,
                  decoration: InputDecoration(
                    labelText: 'Unit',
                    hintText: "ml , g/kg , g/l , g",
                  ),
                ),
              ),
            ],
          ),
          Gap(10.h),
          MyDateField(
            label: 'Application date',
            date: DateTime.now().toIso8601String(),
            onChanged: (s) {
              applicationDate.text = s;
            },
            decoration: InputDecoration(
              labelText: 'Application date',
              suffixIcon: const Icon(Icons.date_range_outlined),
            ),
          ),
          Gap(10.h),
          MyTextField(
            hintText: 'WHP/ ESI/ EAFI',
            controller: whpDays,
            decoration: InputDecoration(
              labelText: 'WHP / ESI / EAFI',
            ),
          ),
          Gap(10.h),
          MyElevatedButton(
            text: 'Save',
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              Get.back();

              final chemicalTableModel = ChemicalTable(
                applicationDate: MyDecoration.formatDate(DateTime.parse(applicationDate.text)),
                chemicalName: productName.text,
                rate: rateController.text + ' ' + unitController.text,
                wHP: whpDays.text,
              );

              widget.onChanged?.call(chemicalTableModel);

              // widget.onChanged!({

              //   'chemicalName': productName.text,
              //   'rate': rateController.text,
              //   'applicationDate': applicationDate.text,
              //   'WHP': whpDays.text,
              // });
            },
          ),
        ],
      ),
    );
  }

  FutureOr<Iterable<WitholdingPeriodModel>> optionsBuilder(TextEditingValue textEditingValue) {
    if (textEditingValue.text.isEmpty) {
      return const Iterable.empty();
    }
    return list.where(
      (element) =>
          element.aPVMARegisteredProductName!.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
          element.productNumber!.toLowerCase().contains(textEditingValue.text.toLowerCase()),
    );
  }

  Widget _optionsViewBuilder(BuildContext context, AutocompleteOnSelected<WitholdingPeriodModel> onSelected,
      Iterable<WitholdingPeriodModel> options) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: SizedBox(
          height: 300.0,
          width: 1.sw * 0.9,
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: options.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);
              return ListTile(
                onTap: () {
                  onSelected(option);
                },
                dense: true,
                title: Text(option.aPVMARegisteredProductName!),
                subtitle: Text('ESI DAYS ' + option.eSIDays!),
                trailing: Text('WHP DAYS ' + option.wHPDays!),
              );
            },
          ),
        ),
      ),
    );
  }

  String _displayStringForOption(WitholdingPeriodModel option) {
    return option.aPVMARegisteredProductName!;
  }

  Widget _fieldViewBuilder(BuildContext context, TextEditingController textEditingController, FocusNode focusNode,
      VoidCallback onFieldSubmitted) {
    return TextField(
      controller: textEditingController,
      focusNode: focusNode,
      onSubmitted: (value) {
        onFieldSubmitted();
      },
      decoration: InputDecoration(
        // contentPadding: kInputPadding,
        suffix: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.clear),
          onPressed: () {
            textEditingController.clear();
          },
        ),
        // suffix: const Icon(Icons.search),
        isDense: true,
        // suffix: ,
        // border: MyDecoration.inputBorder,
        labelText: 'Search for product name',
      ),
    );
  }

  void _onSelected(WitholdingPeriodModel option) {
    setState(() {
      selected = option;
      productName.text = option.aPVMARegisteredProductName!;
      unitController.text = option.unit ?? '';
      rateController.text = option.rate ?? '';

      whpDays.text = '${option.wHPDays!} / ${option.eSIDays} / ';
    });
  }
}
