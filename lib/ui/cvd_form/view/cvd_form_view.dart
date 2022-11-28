import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/cvd_form/cubit/cvd_cubit.dart';
import 'package:background_location/ui/cvd_form/pages/buyer_details.dart';
import 'package:background_location/ui/cvd_form/pages/transporter.dart';
import 'package:background_location/ui/cvd_form/pages/vendor_details.dart';
import 'package:background_location/ui/cvd_form/widgets/chemical_use.dart';
import 'package:background_location/ui/cvd_form/widgets/commodity_details.dart';
import 'package:background_location/ui/cvd_form/widgets/custom_steppar.dart';
import 'package:background_location/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/product_integrity.dart';
import '../widgets/self_declaration.dart';

class CvdFormView extends StatefulWidget {
  const CvdFormView({Key? key}) : super(key: key);

  @override
  State<CvdFormView> createState() => _CvdFormViewState();
}

class _CvdFormViewState extends State<CvdFormView> {
  final controller = PageController();
  late CvdCubit cubit;
  // int index = -1;
  @override
  void initState() {
    cubit = context.read<CvdCubit>();
    cubit.init(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // cubit.getCvdForm();
    return WillPopScope(
      onWillPop: () {
        cubit.saveFormData();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: MyAppBar(
          title: Text('Cvd Form'.toUpperCase()),
          onBackPressed: () {
            cubit.saveFormData();
            Get.back();
          },
        ),
        body: BlocBuilder<CvdCubit, CvdState>(
          builder: (context, state) {
            if (state.isLoading) return Center(child: CircularProgressIndicator());
            // index = -1;
            return Column(
              children: [
                CustomSteppar(
                  onChanged: (value) => cubit.moveToPage(value),
                  currentStep: state.currentStep,
                  stepper: cubit.stepNames,
                  // isCompleted: cubit.isStepCompleted(),
                ),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: cubit.pageController,
                    children: [
                      // CommonPage(data: state.formStepper[0].formDataList),
                      VendorDetails(
                        vendorDetailsModel: cubit.vendorDetails,
                      ),
                      BuyerDetails(
                        buyerDetails: cubit.buyerDetailsModel,
                      ),
                      TransporterDetails(transporDetails: cubit.transporterDetails),
                      // CommonPage(data: state.formStepper[2].formDataList),
                      CommodityDetails(
                        commodityDetails: cubit.commodityDetails,
                      ),
                      ProductIntegrity(
                        productIntegrityDetails: cubit.productIntegrityDetailsModel,
                      ),
                      ChemicalUse(
                        chemicalUseDetailsModel: cubit.chemicalUseDetailsModel,
                      ),
                      const SelfDeclaration(),
                    ].map((e) {
                      return SingleChildScrollView(
                        padding: kPadding,
                        child: e,
                      );
                    }).toList(),
                    // itemBuilder: (context, index) {
                    // final e = state.formStepper.elementAt(index);
                    // final step = FormStepper(
                    //   actions: Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                    //     child: _actions(state, index),
                    //   ),
                    //   heading: e.heading,
                    //   isActive: state.formStepper.indexOf(e) == state.currentStep,
                    //   formDataList: e.formDataList,
                    // );
                    // return Padding(
                    //   padding: kPadding,
                    //   child: step.content,
                    // );
                    // },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget vendorDetails(List<String> fields) {
    return Column();
  }


}
