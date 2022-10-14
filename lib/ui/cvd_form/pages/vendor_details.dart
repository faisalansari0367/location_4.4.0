import 'package:api_repo/api_repo.dart';
import 'package:background_location/helpers/validator.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/text_fields/text_formatters/input_formatters.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../cubit/cvd_cubit.dart';
import '../models/vendor_details_model.dart';
import '../widgets/common_buttons.dart';
import '../widgets/cvd_textfield.dart';

class VendorDetails extends StatefulWidget {
  final VendorDetailsModel vendorDetailsModel;
  const VendorDetails({Key? key, required this.vendorDetailsModel}) : super(key: key);

  @override
  State<VendorDetails> createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails> {
  bool isLoading = false;
  UserData? userData;
  late VendorDetailsModel vendorDetails;
  final formKey = GlobalKey<FormState>();

  //
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    vendorDetails = widget.vendorDetailsModel;
    isLoading = true;
    userData = context.read<Api>().getUserData();
    vendorDetails.fillData(userData?.toJson());
    vendorDetails.address?.value = getAddress();
    vendorDetails.name?.value = userData?.fullName ?? '';
    isLoading = false;
    setState(() {});
  }

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
                name: vendorDetails.name!.label!,
                value: vendorDetails.name?.value,
                onChanged: (value) => vendorDetails.name?.value = value,
              ),
              CvdTextField(
                name: vendorDetails.address!.label!,
                value: vendorDetails.address?.value,
                onChanged: (value) => vendorDetails.address?.value = value,
              ),
              CvdTextField(
                name: vendorDetails.town!.label!,
                value: vendorDetails.town?.value,
                onChanged: (value) => vendorDetails.town?.value = value,
              ),
              PhoneTextField(
                controller: TextEditingController(text: vendorDetails.tel?.value),
                onChanged: (phone, s) => vendorDetails.tel?.value = phone,
              ),
              CvdTextField(
                name: vendorDetails.fax!.label!,
                value: vendorDetails.fax?.value,
                onChanged: (value) => vendorDetails.fax?.value = value,
              ),
              EmailField(
                controller: TextEditingController(text: vendorDetails.email?.value),
                // value: vendorDetails.email?.value,
                onChanged: (value) => vendorDetails.email?.value = value,
              ),
              CvdTextField(
                name: vendorDetails.ngr!.label!,
                value: vendorDetails.ngr?.value,
                onChanged: (value) => vendorDetails.ngr?.value = value,
              ),
              CvdTextField(
                inputFormatters: [CapitalizeAllInputFormatter()],
                maxLength: 8,
                validator: Validator.pic,
                name: vendorDetails.pic!.label!,
                value: vendorDetails.pic?.value,
                onChanged: (value) => vendorDetails.pic?.value = value,
              ),
              CvdTextField(
                name: vendorDetails.refrenceNo!.label!,
                value: vendorDetails.refrenceNo?.value,
                onChanged: (value) => vendorDetails.refrenceNo?.value = value,
              ),
            ],
          ),
        ),
        CommonButtons(
          onContinue: () {
            final isValidated = formKey.currentState!.validate();
            final cubit = context.read<CvdCubit>();
            if (isValidated) {
              cubit.vendorDetails = vendorDetails;
              cubit.changeCurrent(cubit.state.currentStep + 1);
              // cubit.addFormData(formData);
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
