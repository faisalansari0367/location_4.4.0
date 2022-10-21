import 'package:background_location/helpers/validator.dart';
import 'package:background_location/ui/cvd_form/cubit/cvd_cubit.dart';
import 'package:background_location/ui/cvd_form/models/cvd_field_data.dart';
import 'package:background_location/ui/cvd_form/widgets/common_buttons.dart';
import 'package:background_location/ui/cvd_form/widgets/cvd_textfield.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../models/commodity_details_model.dart';

class CommodityDetails extends StatefulWidget {
  final CommodityDetailsModel commodityDetails;
  const CommodityDetails({Key? key, required this.commodityDetails}) : super(key: key);

  @override
  State<CommodityDetails> createState() => _CommodityDetailsState();
}

class _CommodityDetailsState extends State<CommodityDetails> {
  final map = {};
  final formKey = GlobalKey<FormState>();
  late CommodityDetailsModel commodityDetails;
  final units = ['Kg', 'Tonne', 'Lt', 'Bail', 'Roll'];
  String unit = 'Tonne';

  @override
  void initState() {
    super.initState();
    commodityDetails = widget.commodityDetails;
    commodityDetails.deliveryPeriod?.value = DateTime.now().toIso8601String();
    // map['DeliveryPeriod'] = DateTime.now().toIso8601String();
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
            name: commodityDetails.commodity!.label!,
            value: commodityDetails.commodity?.value,
            onChanged: (s) => onChanged(s, commodityDetails.commodity!),
          ),
          CvdTextField(
            name: commodityDetails.variety1!.label!,
            value: commodityDetails.variety1?.value,
            onChanged: (s) => onChanged(s, commodityDetails.variety1!),
          ),
          CvdTextField(
            name: commodityDetails.variety2!.label!,
            value: commodityDetails.variety2?.value,
            validator: Validator.none,
            onChanged: (s) => onChanged(s, commodityDetails.variety2!),
          ),
          MyDateField(
            label: commodityDetails.deliveryPeriod!.label!,
            date: commodityDetails.deliveryPeriod?.value,
            onChanged: (s) => onChanged(s, commodityDetails.deliveryPeriod!),
          ),
          // CvdTextField(
          //   name: 'Variety 1',
          //   value: map['commodity'],
          //   onChanged: (s) {
          //     map['variety2'] = s;
          //     setState(() {});
          //   },
          // ),
          // CvdTextField(
          //   name: 'Variety 2',
          //   value: map['commodity'],
          //   onChanged: (s) {
          //     map['commodity'] = s;
          //     setState(() {});
          //   },
          // ),
          // MyDateField(
          //   label: 'Delivery Period',
          //   date: DateTime.now().toIso8601String(),
          //   // value: map['commodity'],
          //   onChanged: (s) {
          //     map['DeliveryPeriod'] = s;
          //     setState(() {});
          //   },
          // ),
          // CvdTextField(
          //   name: 'Quantity 1',
          //   // value: TextEditingController(),

          //   value: map['Quantity1'],
          //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],

          //   onChanged: (s) {
          //     map['Quantity1'] = s;
          //     setState(() {});
          //   },
          // ),
          // CvdTextField(
          //   name: 'Quantity 2',
          //   value: map['Quantity2'],
          //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],

          //   // controller: TextEditingController(),

          //   onChanged: (s) {
          //     map['Quantity2'] = s;
          //     setState(() {});
          //   },
          // ),
          quantityField(commodityDetails.quantity1!),
          quantityField(commodityDetails.quantity2!, validator: Validator.none),
          MyTextField(
            hintText: 'Total Quantity',
            controller: TextEditingController(text: getTotal()),
            validator: Validator.none,
            onChanged: (s) {
              map['totalQuantity'] = s;
              setState(() {});
            },
          ),

          CommonButtons(
            onContinue: () {
              final cubit = context.read<CvdCubit>();
              if (formKey.currentState?.validate() ?? false) {
                // cubit.addFormData(map);
                // cubit.changeCurrent(0, isNext: true);
                cubit.commodityDetails = commodityDetails;
                // cubit.changeCurrent(cubit.state.currentStep + 1);
                cubit.moveToNext();
                // cubit.
              }
            },
          ),
        ],
      ),
    );
  }

  void onChanged(String value, CvdFieldData data) {
    data.value = value;
  }

  Widget quantityField(CvdFieldData data, {String? Function(String?)? validator}) {
    return Row(
      children: [
        Expanded(
          // flex: 2,
          child: CvdTextField(
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputType: TextInputType.number,
            // hintText: data.label,
            name: data.label!,
            // controller: TextEditingController(text: data.value),
            value: data.value,
            validator: validator,
            onChanged: (s) {
              data.value = s;
              setState(() {});
            },
          ),
        ),
        const Gap(10),
        Expanded(
          child: MyDropdownField(
            hintText: 'Unit',
            value: unit,
            options: units,
            onChanged: (s) {
              // map['totalQuantity'] = s;
              unit = s!;
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  String getTotal() {
    var quantity = 0;
    // final quantity2 = int.parse(commodityDetails.quantity2?.value ?? '0');
    final quantity2 = int.parse(
      (commodityDetails.quantity2?.value?.isEmpty ?? false) ? '0' : (commodityDetails.quantity2?.value ?? '0'),
    );
    final quantity1 = int.parse(
      (commodityDetails.quantity1?.value?.isEmpty ?? false) ? '0' : (commodityDetails.quantity1?.value ?? '0'),
    );

    if (quantity1 != 0) {
      quantity += quantity1;
    }

    if (quantity2 != 0) {
      quantity += quantity2;
    }

    return quantity == 0 ? '' : quantity.toString();
  }
}
