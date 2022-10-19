import 'package:api_repo/api_repo.dart';
import 'package:background_location/ui/cvd_form/models/transporter_details_model.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/text_fields/text_formatters/input_formatters.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../cubit/cvd_cubit.dart';
import '../widgets/common_buttons.dart';
import '../widgets/cvd_textfield.dart';

class TransporterDetails extends StatefulWidget {
  final TransporterDetailsModel transporDetails;
  const TransporterDetails({Key? key, required this.transporDetails}) : super(key: key);

  @override
  State<TransporterDetails> createState() => _TransporterDetailsState();
}

class _TransporterDetailsState extends State<TransporterDetails> {
  bool isLoading = false;
  UserData? userData;
  late TransporterDetailsModel transporterDetails;
  final formKey = GlobalKey<FormState>();

  //
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    transporterDetails = widget.transporDetails;
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
                name: transporterDetails.name!.label!,
                value: transporterDetails.name?.value,
                onChanged: (value) => transporterDetails.name?.value = value,
              ),
              EmailField(
                controller: TextEditingController(text: transporterDetails.email?.value),
                onChanged: (value) => transporterDetails.email?.value = value,
              ),
              PhoneTextField(
                controller: TextEditingController(text: transporterDetails.mobile?.value),
                onChanged: (phone, s) => transporterDetails.mobile?.value = phone,
              ),
              CvdTextField(
                name: transporterDetails.company!.label!,
                value: transporterDetails.company?.value,
                onChanged: (value) => transporterDetails.company?.value = value,
              ),
              CvdTextField(
                inputFormatters: [CapitalizeAllInputFormatter()],
                name: transporterDetails.registration!.label!,
                value: transporterDetails.registration?.value,
                onChanged: (value) => transporterDetails.registration?.value = value,
              ),
            ],
          ),
        ),
        CommonButtons(
          onContinue: () {
            final cubit = context.read<CvdCubit>();
            final isValidated = formKey.currentState!.validate();
            // cubit.addFormData(formData);
            if (isValidated) {
              print(transporterDetails);
              cubit.transporterDetails = transporterDetails;
              // cubit.changeCurrent(cubit.state.currentStep + 1);
              cubit.moveToNext();
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
