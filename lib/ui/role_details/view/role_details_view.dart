import 'package:background_location/constants/index.dart';
import 'package:background_location/ui/role_details/cubit/role_details_cubit.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/my_cross_fade.dart';
import 'package:background_location/widgets/state_dropdown_field.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../helpers/validator.dart';
import '../../../widgets/my_appbar.dart';
import '../../../widgets/signature/signature_widget.dart';
import '../../../widgets/text_fields/text_formatters/input_formatters.dart';
import '../models/field_types.dart';
import '../widgets/property_address.dart';
import '../widgets/species.dart';

class RoleDetailsView extends StatefulWidget {
  const RoleDetailsView({Key? key}) : super(key: key);

  @override
  State<RoleDetailsView> createState() => _RoleDetailsViewState();
}

class _RoleDetailsViewState extends State<RoleDetailsView> {
  final map = <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RoleDetailsCubit>();
    final gap = Gap(1.height);
    return Scaffold(
      appBar: MyAppBar(title: Text(cubit.role)),
      body: SingleChildScrollView(
        padding: kPadding,
        child: BlocBuilder<RoleDetailsCubit, RoleDetailsState>(
          builder: (context, state) {
            return Form(
              key: cubit.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.yourDetails,
                    style: context.textTheme.headline5,
                  ),
                  Gap(3.height),
                  MyCrossFade(
                    isLoading: state.isLoading,
                    child: AutoSpacing(
                      spacing: const SizedBox.shrink(),
                      children: [
                        ...sortedFields(state.fields)
                            .map(
                              (e) => Padding(
                                padding: EdgeInsets.only(bottom: 15.h),
                                child: itemBuilder(e, state),
                              ),
                            )
                            .toList(),
                        // if (state.fields.contains('species'))
                        if (state.userSpecies != null)
                          SpeciesWidget(
                            // data: [],
                            data: state.userSpecies!,
                          )
                        else
                          Container()
                      ],
                      // children: state.fieldsData.map(
                      //   (item) {
                      //     return Padding(
                      //       padding: EdgeInsets.only(top: 10.h),
                      //       child: item.fieldWidget,
                      //     );
                      //   },
                      // ).toList(),
                    ),
                  ),
                  gap,
                  gap,
                  if (!state.isLoading && state.fields.isNotEmpty)
                    MyElevatedButton(
                      // onPressed: cubit.onSubmit,
                      isLoading: state.isLoading,
                      onPressed: () async {
                        // print(map);

                        await cubit.submitFormData(map);
                      },
                      text: 'Submit',
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<String> sortedFields(List<String> fields) {
    final _fields = [...fields];
    final hasSignature = fields.contains('Signature');
    final hasCompanyAddress = fields.contains('Company Address');
    if (hasCompanyAddress) {
      _fields.remove('Company Address');
    }

    if (hasSignature) {
      _fields.remove('Signature');
      _fields.add('Signature');
    }
    return _fields;
  }

  void textEditingControllerListener(TextEditingController controller, String field) {
    controller.addListener(() {
      // print(map);
      if (controller.text.isEmpty) return;
      // if (controller.text == null) return;

      map[field] = controller.text;
      // if (field == FieldType.countryVisiting.name) {
      //   print(map[field]);
      // }
    });
  }

  Widget itemBuilder(String name, RoleDetailsState state) {
    final controller = TextEditingController();
    final userData = state.userRoleDetails;

    if (userData.containsKey(name.toCamelCase)) {
      controller.text = (map[name.toCamelCase] ?? userData[name.toCamelCase] ?? '').toString();
      map[name.toCamelCase] = userData[name.toCamelCase];
    }
    textEditingControllerListener(controller, name.toCamelCase);
    switch (name.toCamelCase) {
      // case FieldType.species:
      //   return SpeciesWidget(data: data);
      // case 'species':
      // if (cubit.state.userSpecies != null)
      //   return SpeciesWidget(
      //     // data: [],
      //     data: cubit.state.userSpecies!,
      //   );
      // else
      //   return Container();
      case 'licenseCategory':
        map[name.toCamelCase] =
            userData[name.toCamelCase] ?? (state.licenseCategories.isEmpty ? null : state.licenseCategories.first);
        return MyDropdownField(
          options: state.licenseCategories,
          value: map[name.toCamelCase],
          onChanged: (value) {
            map[name.toCamelCase] = value;
            setState(() {});
          },
        );

      case 'region':
        return MyTextField(
          hintText: name,
          controller: controller,
        );
      case 'email':
        return EmailField(
          controller: controller,
        );
      case 'phoneNumber':
      case 'mobile':
        controller.text = userData['phoneNumber'] ?? '';
        return PhoneTextField(
          controller: controller,
        );
      case 'pic':
        return MyTextField(
          inputFormatters: [CapitalizeAllInputFormatter()],
          controller: controller,
          hintText: FieldType.pic.name.toUpperCase(),
          validator: Validator.pic,
          maxLength: 8,
        );
      case 'signature':
        // controller.text = userData['signature'] ?? '';
        return SignatureWidget(
          signature: controller.text,
          onChanged: (value) => controller.text = value,
        );
      case 'address':
        return PropertyAddress(
          // address: address,
          onChanged: (value) {
            // address = value;
          },
        );
      // case FieldType.companyAddress:
      // case 'company':
      //   return PropertyAddress(
      //     title: name,
      //     address: Address(

      //     ),
      //     onChanged: (value) {
      //       // address = value;
      //     },
      //   );
      case 'nationalGrowerRegistration(ngr)No:':
        controller.text = userData['ngr'] ?? '';
        return MyTextField(
          controller: controller,
          // textCapitalization: TextCapitalization.characters,
          inputFormatters: [CapitalizeAllInputFormatter()],

          hintText: name,
          onChanged: (s) {
            map['ngr'] = s;
          },

          // validator: Validator.ngr,
          // maxLength: 8,
        );
      // case FieldType.date:
      case 'date':
      case 'entryDate':
      case 'exitDate':
      case 'licenseExpiryDate':
        return MyDateField(
          label: name,
          // date: controller.text,
          date: map[name.toCamelCase] ?? '',
          onChanged: (value) {
            controller.text = value;
            print(map);
          },
        );
      // case FieldType.driversLicense:
      case "driver'sLicense":
        controller.text = map["driver'sLicense"] ?? userData['driversLicense'] ?? '';
        return MyTextField(
          hintText: name,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: Validator.text,
          controller: controller,
          // onChanged: (value) => controller.text = value,
        );

      // case FieldType.countryOfOrigin:
      case 'countryOfOrigin':
        // final controller = TextEditingController();
        // controller.text = map[name.toCamelCase] ?? userData[name.toCamelCase] ?? '';
        return CountryField(
          isOriginCountry: true,
          // isOriginCountry: fieldType.isCountryOfOrigin,
          label: name,
          controller: controller,
          countryName: map[name.toCamelCase] ?? userData[name.toCamelCase],
          onCountryChanged: (value) {
            controller.text = value;
            map[name.toCamelCase] = value;
          },
        );
      // case FieldType.countryVisiting:
      case 'countryVisiting':
        // final controller = TextEditingController();

        return CountryField(
          // isOriginCountry: fieldType.isCountryOfOrigin,

          label: name,
          controller: controller,
          countryName: map[name.toCamelCase] ?? userData[name.toCamelCase],
          onCountryChanged: (value) {
            controller.text = value;
            map[name.toCamelCase] = value;
          },
        );
      // case FieldType.propertyName:
      case 'propertyName':
        // final controller = TextEditingController();
        return MyTextField(
          // isOriginCountry: fieldType.isCountryOfOrigin,
          hintText: name,
          controller: controller,

          inputFormatters: [CapitalizeAllInputFormatter()],
          // countryName: controller.text,
          // onCountryChanged: (value) => controller.text = value,
        );

      // case FieldType.company:
      case 'company':
        //   return MyTextField(
        // final controller = TextEditingController();
        if (controller.text.isNotEmpty) controller.text = controller.text.toUpperCase();
        return MyTextField(
          // isOriginCountry: fieldType.isCountryOfOrigin,
          hintText: name,
          controller: controller,
          validator: Validator.text,
          inputFormatters: [CapitalizeAllInputFormatter()],
          // countryName: controller.text,
          // onCountryChanged: (value) => controller.text = value,
        );
      // case FieldType.city:
      case 'city':
      case 'town':
        // final controller = TextEditingController();
        if (controller.text.isNotEmpty) controller.text = controller.text.toUpperCase();
        return MyTextField(
          // isOriginCountry: fieldType.isCountryOfOrigin,
          hintText: name,
          controller: controller,
          validator: Validator.text,
          inputFormatters: [CapitalizeAllInputFormatter()],
          // textCapitalization: TextCapitalization.characters,
          // countryName: controller.text,
          // onCountryChanged: (value) => controller.text = value,
        );
      case 'postcode':
        // final controller = TextEditingController();
        if (controller.text.isNotEmpty) controller.text = controller.text.toUpperCase();
        return MyTextField(
          // isOriginCountry: fieldType.isCountryOfOrigin,
          maxLength: 4,
          hintText: name,
          controller: controller,
          validator: Validator.postcode,

          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          // textCapitalization: TextCapitalization.characters,
          // countryName: controller.text,
          // onCountryChanged: (value) => controller.text = value,
        );
      // case FieldType.passport:
      case 'passport':
        controller.text = map['passport'] ?? '';
        // final controller = TextEditingController();
        // if (controller.text.isNotEmpty) controller.text = controller.text;
        return MyTextField(
          hintText: name,
          controller: controller,
          validator: Validator.text,
          inputFormatters: const [],
        );
      case 'state':
        // final controller = TextEditingController();
        // return MyTextField(
        //   onTap: () => BottomSheetService.showSheet(
        //     child: States(
        //       onChanged: (value) => setState(() {
        //         controller.text = value;
        //       }),
        //     ),
        //   ),
        //   enabled: true,
        //   inputFormatters: [CapitalizeAllInputFormatter()],
        //   hintText: Strings.selectState,
        //   suffixIcon: Icon(Icons.keyboard_arrow_down),
        //   controller: controller,
        //   focusNode: AlwaysDisabledFocusNode(),
        //   readOnly: false,
        // );
        // if (controller.text.isNotEmpty) controller.text = controller.text;
        // return MyTextField(
        //   hintText: name,
        //   controller: controller,
        //   validator: Validator.text,
        //   inputFormatters: [],
        // );
        return StateDropdownField(
          value: controller.text,
          onChanged: (value) => controller.text = value,
        );

      case 'street':
        return MyTextField(
          hintText: name.capitalize,
          textCapitalization: TextCapitalization.characters,
          controller: controller,
          validator: Validator.text,
        );

      default:
        // final controller = TextEditingController();
        // if (controller.text.isNotEmpty) controller.text = controller.text.capitalizeFirst!;
        // print(name.capitalize);
        return MyTextField(
          hintText: name.capitalize,
          controller: controller,
          validator: Validator.text,
        );
    }
  }
}
