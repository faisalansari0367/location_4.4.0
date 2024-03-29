import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/index.dart';
import 'package:bioplus/helpers/validator.dart';
import 'package:bioplus/ui/forms/widget/form_card.dart';
import 'package:bioplus/ui/role_details/cubit/role_details_cubit.dart';
import 'package:bioplus/ui/role_details/widgets/property_address.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/dialogs/dialog_service.dart';
import 'package:bioplus/widgets/my_appbar.dart';
import 'package:bioplus/widgets/my_cross_fade.dart';
import 'package:bioplus/widgets/signature/signature_widget.dart';
import 'package:bioplus/widgets/state_dropdown_field.dart';
import 'package:bioplus/widgets/text_fields/text_formatters/input_formatters.dart';
import 'package:bioplus/widgets/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleDetailsView extends StatefulWidget {
  const RoleDetailsView({super.key});

  @override
  State<RoleDetailsView> createState() => _RoleDetailsViewState();
}

class _RoleDetailsViewState extends State<RoleDetailsView> {
  final map = <String, dynamic>{};
  UserData? _userData;
  @override
  void initState() {
    _userData = context.read<Api>().getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RoleDetailsCubit>();
    final gap = Gap(1.height);
    return Scaffold(
      appBar: MyAppBar(title: Text(cubit.role)),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: kPadding,
        child: BlocBuilder<RoleDetailsCubit, RoleDetailsState>(
          builder: (context, state) {
            return Form(
              key: cubit.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   Strings.yourDetails,
                  //   style: context.textTheme.headlineSmall,
                  // ),
                  // Gap(3.height),
                  // StreamBuilder<UserData?>(
                  //   stream: context.read<Api>().userDataStream,
                  //   builder: (context, snapshot) => UserProfileWidget(
                  //     user: context.read<Api>().getUserData()!,
                  //   ),
                  // ),
                  UserProfileWidget(
                    user: context.read<Api>().getUserData()!,
                  ),
                  Gap(3.height),
                  MyCrossFade(
                    isLoading: state.isLoading,
                    child: AutoSpacing(
                      spacing: const SizedBox.shrink(),
                      children: [
                        ...sortedFields(state.fields).map(
                          (e) => Padding(
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: itemBuilder(e, state),
                          ),
                        ),
                        // if (state.userSpecies != null)
                        //   SpeciesWidget(
                        //     data: state.userSpecies!,
                        //   )
                        // else
                        //   Container(),
                      ],
                    ),
                  ),
                  gap,
                  gap,
                  if (!state.isLoading && state.fields.isNotEmpty)
                    MyElevatedButton(
                      isLoading: state.isLoading,
                      onPressed: () async {
                        try {
                          await cubit.submitFormData(map);
                        } catch (e) {
                          DialogService.error('Something went wrong');
                        }
                      },
                      text: 'Submit',
                    ),
                  gap,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<String> sortedFields(List<String> fields) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _fields = [...fields];
    _fields.remove('Species');
    // _fields.remove(Strings.lastName);
    // _fields.remove(Strings.firstName);
    // _fields.remove(Strings.mobile);
    // _fields.remove(Strings.email.toLowerCase());
    // _fields.remove(Strings.emergencyEmailContact);
    // _fields.remove(Strings.emergencyMobileContact);
    // _fields.remove('Company Name');
    // _fields.remove('Company Address');
    final hasSignature = fields.contains('Signature');
    // final hasCompanyAddress = fields.contains('Company Address');
    // if (hasCompanyAddress) {
    //   _fields.remove('Company Address');
    // }

    if (hasSignature) {
      _fields.remove('Signature');
      _fields.add('Signature');
    }
    return _fields;
  }

  void textEditingControllerListener(
    TextEditingController controller,
    String field,
  ) {
    controller.addListener(() {
      // if (controller.text.isEmpty) return;

      map[field] = controller.text;
    });
  }

  Widget itemBuilder(String name, RoleDetailsState state) {
    final controller = TextEditingController();
    final userData = state.userRoleDetails;

    if (userData.containsKey(name.toCamelCase)) {
      final data = map[name.toCamelCase] ?? userData[name.toCamelCase] ?? '';
      final value = data is List ? data.join(',') : data.toString();
      controller.text = value;
      map[name.toCamelCase] = value;
    }
    textEditingControllerListener(controller, name.toCamelCase);
    switch (name.toCamelCase) {
      case 'sector':
        map[name.toCamelCase] = 'Government';

        return MyDropdownField(
          hintText: 'Please select Sector',
          options: const [
            'Government',
            'Agriculture',
            'Water',
            'Gas',
            'Power',
            'Waste'
          ],
          value: map[name.toCamelCase],
          onChanged: (value) {
            map[name.toCamelCase] = value;
            setState(() {});
          },
        );

      case 'licenseCategory':
        map[name.toCamelCase] = userData[name.toCamelCase] ??
            (state.licenseCategories.isEmpty
                ? null
                : state.licenseCategories.first);
        return MyDropdownField(
          options: state.licenseCategories,
          hintText: name,
          value: map[name.toCamelCase] ?? '',
          onChanged: (value) {
            map[name.toCamelCase] = value;
            setState(() {});
          },
        );

      case 'contactName':
        controller.text = _userData?.fullName ?? '';
        return MyTextField(
          hintText: name,
          controller: controller,
        );

      case 'region':
        return MyTextField(
          hintText: name,
          controller: controller,
        );
      case 'email':
        return EmailField(
          readOnly: true,
          label: name,
          controller: controller,
        );
      case 'contactEmail':
      case 'emergencyEmailContact':
        return EmailField(
          label: name,
          controller: controller,
        );
      case 'emergencyMobileContact':
        controller.text = userData['emergencyMobileContact'] ?? '';
        return PhoneTextField(
          controller: controller,
          hintText: name,
          // controller: ,
          onChanged: (number, countryCode) {
            map[name.toCamelCase] = number;
          },
        );
      case 'phoneNumber':
      case 'contactNumber':
      case 'mobile':
        controller.text = userData['phoneNumber'] ?? '';
        return PhoneTextField(controller: controller);
      case 'pic':
        return MyTextField(
          inputFormatters: [CapitalizeAllInputFormatter()],
          controller: controller,
          hintText: name.toUpperCase(),
          validator: Validator.pic,
          maxLength: 8,
        );
      case 'signature':
        return SignatureWidget(
          signature: controller.text,
          onChanged: (value) => controller.text = value,
        );
      case 'address':
        return PropertyAddress(
          onChanged: (value) {},
        );

      case 'nationalGrowerRegistration(ngr)No:':
        controller.text = userData['ngr'] ?? '';
        return MyTextField(
          controller: controller,
          inputFormatters: [CapitalizeAllInputFormatter()],
          hintText: name,
          validator: Validator.none,
          onChanged: (s) {
            map['ngr'] = s;
          },
        );

      case 'licenseExpiryDate':
        return MyDateField(
          label: name,
          validator: Validator.none,
          date: map[name.toCamelCase] ?? '',
          onChanged: (value) {
            controller.text = value;
          },
        );

      case 'date':
      case 'entryDate':

      case 'endDate':
      case 'exitDate':
        return MyDateField(
          label: name,
          date: map[name.toCamelCase] ?? '',
          onChanged: (value) {
            controller.text = value;
          },
        );
      case 'startDate':
        map[name.toCamelCase] =
            userData[name.toCamelCase] ?? DateTime.now().toIso8601String();
        return MyDateField(
          label: name,
          date: map[name.toCamelCase] ?? '',
          onChanged: (value) {
            controller.text = value;
          },
        );

      case "edec":
        return QuestionCard(
          question: name,
          selectedValue: controller.text.toLowerCase() == 'Yes'.toLowerCase(),
          onChanged: (s) {
            controller.text = s ? 'Yes' : 'No';
            setState(() {});
          },
        );
      case "driver'sLicense":
        controller.text =
            map["driver'sLicense"] ?? userData['driversLicense'] ?? '';
        return MyTextField(
          hintText: name,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: Validator.none,
          controller: controller,
        );

      case 'countryOfOrigin':
        return CountryField(
          isOriginCountry: true,
          label: name,
          controller: controller,
          countryName: map[name.toCamelCase] ?? userData[name.toCamelCase],
          onCountryChanged: (value) {
            controller.text = value;
            map[name.toCamelCase] = value;
          },
        );

      case 'countryVisiting':
        return CountryField(
          label: name,
          controller: controller,
          countryName: map[name.toCamelCase] ?? userData[name.toCamelCase],
          onCountryChanged: (value) {
            controller.text = value;
            map[name.toCamelCase] = value;
          },
        );
      case 'countryOfResidency':
        return CountryField(
          label: name,
          controller: controller,
          countryName: map[name.toCamelCase] ?? userData[name.toCamelCase],
          onCountryChanged: (value) {
            controller.text = value;
            map[name.toCamelCase] = value;
          },
        );

      case 'propertyName':
        return MyTextField(
          hintText: name,
          controller: controller,
          validator: Validator.none,
          inputFormatters: [CapitalizeAllInputFormatter()],
        );

      case 'company':
        if (controller.text.isNotEmpty) {
          controller.text = controller.text.toUpperCase();
        }
        return MyTextField(
          hintText: name,
          controller: controller,
          validator: context.read<RoleDetailsCubit>().role == 'Visitor'
              ? Validator.none
              : Validator.text,
          inputFormatters: [CapitalizeAllInputFormatter()],
        );

      case 'city':
      case 'town':
        if (controller.text.isNotEmpty) {
          controller.text = controller.text.toUpperCase();
        }
        return MyTextField(
          hintText: name,
          controller: controller,
          validator: Validator.text,
          inputFormatters: [CapitalizeAllInputFormatter()],
        );
      case 'postcode':
        if (controller.text.isNotEmpty) {
          controller.text = controller.text.toUpperCase();
        }
        return MyTextField(
          maxLength: 4,
          hintText: name,
          controller: controller,
          validator: Validator.postcode,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        );

      case 'passport':
        controller.text = map['passport'] ?? '';

        return MyTextField(
          hintText: name,
          controller: controller,
          validator: Validator.text,
          inputFormatters: const [],
        );
      case 'state':
        return StateDropdownField(
          value: controller.text,
          onChanged: (value) => controller.text = value,
        );

      case 'street':
        return MyTextField(
          hintText: name.capitalize,
          // textCapitalization: ,
          inputFormatters: [CapitalizeAllInputFormatter()],
          controller: controller,
          validator: Validator.text,
        );
      case 'lpaUsername':
        return MyTextField(
          hintText: 'LPA Username',
          // textCapitalization: TextCapitalization.characters,
          controller: controller,
          validator: Validator.none,
        );
      case 'lpaPassword':
        return PasswordField(
          hintText: 'LPA Password',
          controller: controller,
          validator: Validator.none,
        );
      case 'nlisPassword':
        return PasswordField(
          hintText: 'NLIS Password',
          controller: controller,
          validator: Validator.none,
        );
      case 'msaNumber':
        return MyTextField(
          hintText: 'MSA Number',
          controller: controller,
          validator: Validator.none,
        );
      case 'nfasAccreditationNumber':
        return MyTextField(
          hintText: 'NFAS Accreditation Number',
          controller: controller,
          validator: Validator.none,
        );

      case 'nlisUsername':
        return MyTextField(
          hintText: 'NLIS Username',
          controller: controller,
          validator: Validator.none,
        );

      default:
        return MyTextField(
          hintText: name.capitalize,
          controller: controller,
          validator: Validator.text,
        );
    }
  }
}
