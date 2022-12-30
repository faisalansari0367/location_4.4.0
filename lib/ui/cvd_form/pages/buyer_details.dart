import 'package:api_repo/api_repo.dart';
import 'package:bioplus/helpers/validator.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/text_fields/text_formatters/input_formatters.dart';
import 'package:bioplus/widgets/widgets.dart';
import 'package:cvd_forms/models/src/buyer_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../cubit/cvd_cubit.dart';
// import '../models/buyer_details_model.dart';
import '../widgets/common_buttons.dart';
import '../widgets/cvd_textfield.dart';

class BuyerDetails extends StatefulWidget {
  final BuyerDetailsModel buyerDetails;
  const BuyerDetails({Key? key, required this.buyerDetails}) : super(key: key);

  @override
  State<BuyerDetails> createState() => _BuyerDetailsState();
}

class _BuyerDetailsState extends State<BuyerDetails> {
  bool isLoading = false;
  UserData? userData;
  late BuyerDetailsModel buyerDetails;
  final formKey = GlobalKey<FormState>();

  //
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    buyerDetails = widget.buyerDetails;
  }

  //   * Fax
  // * NGR
  // * PIC
  // * Buyers contract number

  @override
  Widget build(BuildContext context) {
    if (isLoading) const Center(child: CircularProgressIndicator());
    return Column(
      children: [
        Form(
          key: formKey,
          child: AutoSpacing(
            spacing: Gap(15.h),
            children: [
              CvdTextField(
                name: buyerDetails.name!.label!,
                value: buyerDetails.name?.value,
                onChanged: (value) => buyerDetails.name?.value = value,
              ),
              CvdTextField(
                name: buyerDetails.address!.label!,
                value: buyerDetails.address?.value,
                onChanged: (value) => buyerDetails.address?.value = value,
              ),
              CvdTextField(
                name: buyerDetails.town!.label!,
                value: buyerDetails.town?.value,
                onChanged: (value) => buyerDetails.town?.value = value,
              ),
              PhoneTextField(
                controller: TextEditingController(text: buyerDetails.tel?.value),
                onChanged: (phone, s) => buyerDetails.tel?.value = phone,
              ),
              CvdTextField(
                name: buyerDetails.fax!.label!,
                value: buyerDetails.fax?.value,
                validator: Validator.none,
                onChanged: (value) => buyerDetails.fax?.value = value,
              ),
              EmailField(
                controller: TextEditingController(text: buyerDetails.email?.value),
                // value: vendorDetails.email?.value,
                onChanged: (value) => buyerDetails.email?.value = value,
              ),
              CvdTextField(
                name: buyerDetails.ngr!.label!,
                value: buyerDetails.ngr?.value,
                validator: Validator.none,
                onChanged: (value) => buyerDetails.ngr?.value = value,
              ),
              CvdTextField(
                inputFormatters: [CapitalizeAllInputFormatter()],
                maxLength: 8,
                // validator: Validator.pic,
                validator: Validator.none,

                name: buyerDetails.pic!.label!,
                value: buyerDetails.pic?.value,
                onChanged: (value) => buyerDetails.pic?.value = value,
              ),
              if (buyerDetails.contractNo?.label != null)
                CvdTextField(
                  validator: Validator.none,
                  name: buyerDetails.contractNo!.label!,
                  value: buyerDetails.contractNo?.value,
                  onChanged: (value) => buyerDetails.contractNo?.value = value,
                ),
            ],
          ),
        ),
        CommonButtons(
          onContinue: () {
            final isValidated = formKey.currentState!.validate();
            final cubit = context.read<CvdCubit>();
            // cubit.addFormData(formData);
            if (isValidated) {
              // cubit.buyerDetailsModel = buyerDetails;
              cubit.setBuyerDetails(buyerDetails);
              cubit.moveToNext();
              // print(buyerDetails);
            }
          },
        ),
        Gap(50.h),
      ],
    );
  }

  String getAddress() {
    var address = '';
    address += userData?.street ?? '';
    address += ' ';
    address += userData?.town ?? '';
    address += ' ';
    address += userData?.state ?? '';
    address += ' ';
    if (userData?.postcode != null) address += userData!.postcode!.toString();
    return address.trim();
  }
}
