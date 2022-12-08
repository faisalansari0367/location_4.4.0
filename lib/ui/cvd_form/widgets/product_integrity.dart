import 'package:bioplus/ui/cvd_form/cubit/cvd_cubit.dart';
import 'package:bioplus/ui/cvd_form/models/chemical_use.dart';
import 'package:bioplus/ui/cvd_form/models/product_integrity_details_model.dart';
import 'package:bioplus/ui/cvd_form/widgets/common_buttons.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ProductIntegrity extends StatefulWidget {
  final ProductIntegrityDetailsModel productIntegrityDetails;
  const ProductIntegrity({Key? key, required this.productIntegrityDetails}) : super(key: key);

  @override
  State<ProductIntegrity> createState() => _ProductIntegrityState();
}

class _ProductIntegrityState extends State<ProductIntegrity> {
  ProductIntegrityDetailsModel? form;
  final formData = <String, Set<int>>{};

  @override
  void initState() {
    form = widget.productIntegrityDetails;
    final cubit = context.read<CvdCubit>();
    final _map = cubit.map[cubit.stepNames[cubit.state.currentStep]];
    final data = _map ?? {};
    if (data.isNotEmpty) {
      data.forEach((key, value) {
        formData[key] = value.toSet();
      });
    }
    // _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (form == null) return const SizedBox();

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Part A - Product Integrity',
            style: context.textTheme.headline6?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(20.h),
          // ...form!.data!.question1!
          qna(
            form!.sourceCheck!,
            0,
            // children: [
            //   MyTextField(),
            //   MyTextField(),
            //   MyTextField(),
            //   MyTextField(),
            // ],
          ),
          qna(form!.materialCheck!, 1),
          qna(form!.gmoCheck!, 2),
          CommonButtons(
            onContinue: () {
              for (var item in form!.toJson().values) {
                if (item['value'] == null) {
                  DialogService.error(
                    'Please fill ${item['field']}',
                  );
                  return;
                }
              }
              // if (formData.length < 3) {
              //   DialogService.error('Please answer all the questions');
              //   return;
              // }

              // final newMap = {};
              // formData.forEach((key, value) {
              //   newMap[key] = value.toList();
              // });
              // print(formData);
              final cubit = context.read<CvdCubit>();
              // cubit.addFormData(newMap);
              cubit.productIntegrityDetailsModel = form!;
              // cubit.changeCurrent(cubit.state.currentStep + 1);
              cubit.moveToNext();
            },
          ),

          // .map(
          //   (e) => qna(e, form!.data!.indexOf(e)),
          // )
          // .toList(),
        ],
      ),
    );
  }

  Widget qna(FieldData data, int index, {List<Widget> children = const []}) {
    return Container(
      // decoration: BoxDecoration(),
      // padding: kPadding.copyWith(

      // ),
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        // horizontal: 10.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}. ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.w,
                ),
              ),
              Expanded(
                child: Text(
                  data.field ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.w,
                  ),
                ),
              ),
            ],
          ),
          Gap(10.h),
          ...data.options!
              .map(
                (e) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: CheckboxListTile(
                    // value: getVlaue(data.field.va, int.parse(e.value!)),
                    value: e.value == data.value,
                    onChanged: (s) {
                      if (s == true) {
                        setState(() {
                          data.value = e.value;
                        });
                      }
                    },
                    title: Text(
                      e.label!,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          if (data.value == 'yes' && children.isNotEmpty) ...[
            Gap(10.h),
            ...children,
          ]
        ],
      ),
    );
  }

  bool? getVlaue(String? field, int? id) {
    final data = formData[field!];
    if (data == null) return false;
    if (data is int) return {data}.contains(id);
    return (formData[field])?.contains(id);
  }

  void setValue(String? field, int? id, {bool canSelectOne = false}) {
    final dataSet = <int>{};
    final data = formData[field!];
    if (data == null) {
      dataSet.add(id!);
      formData[field] = dataSet;
    } else {
      if (!canSelectOne) dataSet.addAll(data);
      dataSet.contains(id!) ? dataSet.remove(id) : dataSet.add(id);
      formData[field] = dataSet;
    }
    print(formData);
  }

  // Future<void> _init() async {
  //   final data = await DefaultAssetBundle.of(context).loadString('assets/json/part_integrity_form.json');
  //   final map = jsonDecode(data);
  //   form = ProductIntegrityModel.fromJson(map);
  //   setState(() {});
  // }
}
