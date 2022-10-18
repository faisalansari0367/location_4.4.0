import 'package:api_repo/api_repo.dart';
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
  // late widget.VendorDetailsModel widget.vendorDetails;
  final formKey = GlobalKey<FormState>();

  //
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // final vendorDetails = widget.vendorDetailsModel;
    isLoading = true;
    userData = context.read<Api>().getUserData();
    widget.vendorDetailsModel.fillData(userData?.toJson());
    widget.vendorDetailsModel.address?.value = getAddress();
    widget.vendorDetailsModel.name?.value = userData?.fullName ?? '';
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
                name: widget.vendorDetailsModel.name!.label!,
                value: widget.vendorDetailsModel.name?.value,
                onChanged: (value) => widget.vendorDetailsModel.name?.value = value,
              ),
              CvdTextField(
                name: widget.vendorDetailsModel.address!.label!,
                value: widget.vendorDetailsModel.address?.value,
                onChanged: (value) => widget.vendorDetailsModel.address?.value = value,
              ),
              CvdTextField(
                name: widget.vendorDetailsModel.town!.label!,
                value: widget.vendorDetailsModel.town?.value,
                onChanged: (value) => widget.vendorDetailsModel.town?.value = value,
              ),
              PhoneTextField(
                controller: TextEditingController(text: widget.vendorDetailsModel.tel?.value),
                onChanged: (phone, s) => widget.vendorDetailsModel.tel?.value = phone,
              ),
              CvdTextField(
                name: widget.vendorDetailsModel.fax!.label!,
                value: widget.vendorDetailsModel.fax?.value,
                validator: (String? s) => null,
                onChanged: (value) => widget.vendorDetailsModel.fax?.value = value,
              ),
              EmailField(
                controller: TextEditingController(text: widget.vendorDetailsModel.email?.value),
                // value: widget.vendorDetailsModel.email?.value,
                onChanged: (value) => widget.vendorDetailsModel.email?.value = value,
              ),
              CvdTextField(
                name: widget.vendorDetailsModel.ngr!.label!,
                value: widget.vendorDetailsModel.ngr?.value,
                validator: (String? s) => null,
                onChanged: (value) => widget.vendorDetailsModel.ngr?.value = value,
              ),
              CvdTextField(
                inputFormatters: [CapitalizeAllInputFormatter()],
                maxLength: 8,
                // validator: Validator.pic,
                validator: (String? s) => null,

                name: widget.vendorDetailsModel.pic!.label!,
                value: widget.vendorDetailsModel.pic?.value,
                onChanged: (value) => widget.vendorDetailsModel.pic?.value = value,
              ),
              CvdTextField(
                name: widget.vendorDetailsModel.refrenceNo!.label!,
                value: widget.vendorDetailsModel.refrenceNo?.value,
                onChanged: (value) => widget.vendorDetailsModel.refrenceNo?.value = value,
                validator: (String? s) => null,
              ),
            ],
          ),
        ),
        CommonButtons(
          onContinue: () {
            final isValidated = formKey.currentState!.validate();
            final cubit = context.read<CvdCubit>();
            if (isValidated) {
              cubit.vendorDetails = widget.vendorDetailsModel;
              cubit.moveToNext();
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
