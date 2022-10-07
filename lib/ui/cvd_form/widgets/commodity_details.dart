import 'package:background_location/ui/cvd_form/cubit/cvd_cubit.dart';
import 'package:background_location/ui/cvd_form/widgets/common_buttons.dart';
import 'package:background_location/ui/cvd_form/widgets/cvd_textfield.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CommodityDetails extends StatefulWidget {
  const CommodityDetails({Key? key}) : super(key: key);

  @override
  State<CommodityDetails> createState() => _CommodityDetailsState();
}

class _CommodityDetailsState extends State<CommodityDetails> {
  final map = {};
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    map['DeliveryPeriod'] = DateTime.now().toIso8601String();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: AutoSpacing(
        spacing: Gap(15.h),
        children: [
          // "Commodity",
          //   'Variety 1',
          //   'Variety 2',

          //   'Delivery Period',
          //   'Quantity 1',
          //   'Quantity 2',

          //   "Total Quantity",
          CvdTextField(
            name: 'Commodity',
            value: map['commodity'],
            onChanged: (s) {
              map['variety1'] = s;
              setState(() {});
            },
          ),
          CvdTextField(
            name: 'Variety 1',
            value: map['commodity'],
            onChanged: (s) {
              map['variety2'] = s;
              setState(() {});
            },
          ),
          CvdTextField(
            name: 'Variety 2',
            value: map['commodity'],
            onChanged: (s) {
              map['commodity'] = s;
              setState(() {});
            },
          ),
          MyDateField(
            label: 'Delivery Period',
            date: DateTime.now().toIso8601String(),
            // value: map['commodity'],
            onChanged: (s) {
              map['DeliveryPeriod'] = s;
              setState(() {});
            },
          ),
          CvdTextField(
            name: 'Quantity 1',
            // value: TextEditingController(),

            value: map['Quantity1'],
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],

            onChanged: (s) {
              map['Quantity1'] = s;
              setState(() {});
            },
          ),
          CvdTextField(
            name: 'Quantity 2',
            value: map['Quantity2'],
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],

            // controller: TextEditingController(),
            onChanged: (s) {
              map['Quantity2'] = s;
              setState(() {});
            },
          ),

          MyTextField(
            hintText: 'Total Quantity',
            controller: TextEditingController(text: getTotal()),
            onChanged: (s) {
              map['totalQuantity'] = s;
              setState(() {});
            },
          ),

          CommonButtons(
            onContinue: () {
              if (formKey.currentState?.validate() ?? false) {
                final cubit = context.read<CvdCubit>();
                cubit.addFormData(map);
                cubit.changeCurrent(0, isNext: true);
              }
            },
          ),
        ],
      ),
    );
  }

  String getTotal() {
    var quantity = 0;
    final quantity2 = map['Quantity2'];
    final quantity1 = map['Quantity1'];

    if (quantity1 != null) {
      final value = int.tryParse(quantity1);
      if (value != null) quantity += value;
    }

    if (quantity2 != null) {
      final value = int.tryParse(quantity2);
      if (value != null) quantity += value;
    }

    return quantity == 0 ? '' : quantity.toString();
  }
}
