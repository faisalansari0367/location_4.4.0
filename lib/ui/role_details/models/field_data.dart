import 'package:background_location/constants/index.dart';
import 'package:background_location/helpers/validator.dart';
import 'package:background_location/ui/role_details/models/field_types.dart';
import 'package:background_location/ui/role_details/widgets/species.dart';
import 'package:background_location/widgets/signature/signature_widget.dart';
import 'package:background_location/widgets/text_fields/text_formatters/input_formatters.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../widgets/property_address.dart';

class FieldData {
  final String name;
  Address? address;
  final Map<String, dynamic> data;
  final TextEditingController controller;

  FieldData({
    required this.name,
    required this.controller,
    this.address,
    this.data = const {},
  });

  FieldType get fieldType {
    switch (name.toCamelCase) {
      case 'email':
        return FieldType.email;
      case 'mobile':
      case 'phoneNumber':
        return FieldType.phoneNumber;
      case 'signature':
        return FieldType.signature;
      case 'pic':
        return FieldType.pic;
      case 'address':
        return FieldType.address;
      case 'companyAddress':
        return FieldType.companyAddress;
      case 'region':
        return FieldType.region;
      case "driver'sLicense":
        return FieldType.driversLicense;
      case 'entryDate':
      // return
      case 'exitDate':
      case 'licenseExpiryDate':
      case 'day/date/time':
        return FieldType.date;
      case 'countryOfOrigin':
        return FieldType.countryOfOrigin;
      case 'countryVisiting':
        return FieldType.countryVisiting;
      case 'propertyName':
        return FieldType.propertyName;
      case 'city':
        return FieldType.city;
      case 'town':
        return FieldType.town;
      case 'passport':
        return FieldType.passport;
      case 'company':
        return FieldType.company;
      case 'species':
        return FieldType.species;
      case 'licenseCategory':
        return FieldType.licenseCategory;
      default:
        return FieldType.text;
      // return SizedBox.shrink();
    }
  }

  Widget get fieldWidget {
    switch (fieldType) {
      // case FieldType.species:
      //   return SpeciesWidget(data: data);
      case FieldType.species:
        return SpeciesWidget(
          data: data['species'],
        );

      case FieldType.licenseCategory:
        return MyDropdownField(
          onChanged: (p0) => controller.text = p0!,
          value: controller.text,
          hintText: name,
          options: [
            "Car (C) Licence",
            "Light Rigid (LR) Licence",
            "Medium Rigid (MR) Licence",
            "Heavy Rigid (HR) Licence",
            "Heavy Combination (HC) Licence",
            "Multi Combination (MC) Licence",
            "Rider (R) Licence",
          ],
        );
      case FieldType.region:
        return MyTextField(
          hintText: name,
          controller: controller,
        );
      case FieldType.email:
        return EmailField(
          controller: controller,
        );
      case FieldType.phoneNumber:
        return PhoneTextField(
          controller: controller,
        );
      case FieldType.pic:
        return MyTextField(
          inputFormatters: [CapitalizeAllInputFormatter()],
          controller: controller,
          hintText: FieldType.pic.name.toUpperCase(),
          validator: Validator.pic,
          maxLength: 8,
        );
      case FieldType.signature:
        return SignatureWidget(
          signature: controller.text,
          // controller: controller,
          onChanged: (value) => controller.text = value,
        );
      case FieldType.address:
        return PropertyAddress(
          address: address,
          onChanged: (value) {
            address = value;
          },
        );
      case FieldType.companyAddress:
        return PropertyAddress(
          title: name,
          address: address,
          onChanged: (value) {
            address = value;
          },
        );
      case FieldType.date:
        return MyDateField(
          label: name,
          date: controller.text,
          onChanged: (value) {
            controller.text = value;
          },
        );
      case FieldType.driversLicense:
        return MyTextField(
          hintText: name,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
          validator: Validator.text,
          controller: controller,
          // onChanged: (value) => controller.text = value,
        );

      case FieldType.countryOfOrigin:
        return CountryField(
          isOriginCountry: fieldType.isCountryOfOrigin,
          label: name,
          controller: controller,
          countryName: controller.text,
          onCountryChanged: (value) => controller.text = value,
        );
      case FieldType.countryVisiting:
        return CountryField(
          // isOriginCountry: fieldType.isCountryOfOrigin,
          label: name,
          controller: controller,
          countryName: controller.text,
          onCountryChanged: (value) => controller.text = value,
        );
      case FieldType.propertyName:
        return MyTextField(
          // isOriginCountry: fieldType.isCountryOfOrigin,
          hintText: name,
          controller: controller,
          inputFormatters: [CapitalizeAllInputFormatter()],
          // countryName: controller.text,
          // onCountryChanged: (value) => controller.text = value,
        );

      case FieldType.company:
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
      case FieldType.city:
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
      case FieldType.passport:
        if (controller.text.isNotEmpty) controller.text = controller.text;
        return MyTextField(
          hintText: name,
          controller: controller,
          validator: Validator.text,
          inputFormatters: [],
        );

      default:
        if (controller.text.isNotEmpty) controller.text = controller.text.capitalize!;
        return MyTextField(
          hintText: name.capitalize,
          controller: controller,
          validator: getValidator(),
        );
    }
  }

  String? Function(String?)? getValidator() {
    switch (fieldType) {
      case FieldType.email:
        return Validator.email;
      case FieldType.phoneNumber:
        return Validator.mobileNo;
      default:
        return Validator.text;
    }
  }
}
