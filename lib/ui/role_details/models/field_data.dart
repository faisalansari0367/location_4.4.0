import 'package:background_location/helpers/validator.dart';
import 'package:background_location/ui/role_details/models/field_types.dart';
import 'package:background_location/widgets/signature/signature_widget.dart';
import 'package:background_location/widgets/text_fields/country_field.dart';
import 'package:background_location/widgets/text_fields/date_field.dart';
import 'package:background_location/widgets/text_fields/phone_text_field.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../widgets/property_address.dart';

class FieldData {
  final String name;
  Address? address;
  final TextEditingController controller;

  FieldData({
    required this.name,
    required this.controller,
    this.address,
  });

  FieldType get fieldType {
    switch (name.camelCase) {
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
      case 'entryDate':
      case 'exitDate':
        return FieldType.date;
      case 'countryOfOrigin':
      case 'countryVisiting':
        return FieldType.country;
      default:
        return FieldType.text;
    }
  }

  Widget get fieldWidget {
    switch (fieldType) {
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
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [],
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
          onChanged: (value) {
            address = value;
            print(address?.toMap());
          },
        );
      case FieldType.date:
        return MyDateField(
          label: name,
          date: controller.text,
          onChanged: (value) => controller.text = value,
        );
      // case FieldType.exitDate:
      //   return MyDateField(
      //     label: name,
      //     onChanged: (value) => controller.text = value,
      //   );

      case FieldType.country:
        return CountryField(
          label: name,
          controller: controller,
          countryName: controller.text,
          onCountryChanged: (value) => controller.text = value,
        );

      default:
        return MyTextField(
          hintText: name,
          controller: controller,
          validator: getValidator(),
        );
    }
  }

  // Map<String, dynamic>

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
