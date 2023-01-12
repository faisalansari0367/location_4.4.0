import 'package:bioplus/constants/index.dart';
import 'package:bioplus/ui/cvd_form/cubit/cvd_cubit.dart';
import 'package:bioplus/ui/cvd_form/pages/buyer_details.dart';
import 'package:bioplus/ui/cvd_form/pages/transporter.dart';
import 'package:bioplus/ui/cvd_form/pages/vendor_details.dart';
import 'package:bioplus/ui/cvd_form/widgets/chemical_use.dart';
import 'package:bioplus/ui/cvd_form/widgets/commodity_details.dart';
import 'package:bioplus/ui/cvd_form/widgets/custom_steppar.dart';
import 'package:bioplus/ui/cvd_form/widgets/product_integrity.dart';
import 'package:bioplus/ui/cvd_form/widgets/self_declaration.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CvdFormView extends StatefulWidget {
  const CvdFormView({super.key});

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
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                CustomSteppar(
                  onChanged: (value) => cubit.moveToPage(value),
                  currentStep: state.currentStep,
                  stepper: cubit.stepNames,
                ),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: cubit.pageController,
                    children: [
                      VendorDetails(
                        vendorDetailsModel: cubit.vendorDetailsModel,
                      ),
                      BuyerDetails(
                        buyerDetails: cubit.buyerDetailsModel,
                      ),
                      TransporterDetails(
                        transporDetails: cubit.transporterDetailsModel,
                      ),
                      // CommonPage(data: state.formStepper[2].formDataList),
                      CommodityDetails(
                        commodityDetails: cubit.commodityDetailsModel,
                      ),
                      ProductIntegrity(
                        productIntegrityDetails:
                            cubit.productIntegrityDetailsModel,
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
