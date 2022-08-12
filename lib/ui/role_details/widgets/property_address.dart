// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:background_location/constants/index.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/helpers/validator.dart';
import 'package:background_location/ui/role_details/widgets/states.dart';
import 'package:background_location/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class Address {
  int? postcode;
  String? street;
  String? state;
  String? town;

  Address({
    this.town,
    this.street,
    this.state,
    this.postcode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postcode': postcode,
      'street': street,
      'state': state,
      'town': town,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      postcode: map['postcode'] != null ? map['postcode'] as int : null,
      street: map['street'] != null ? map['street'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      town: map['town'] != null ? map['town'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PropertyAddress extends StatefulWidget {
  final ValueChanged<Address>? onChanged;
  const PropertyAddress({Key? key, this.onChanged}) : super(key: key);

  @override
  State<PropertyAddress> createState() => _PropertyAddressState();
}

class _PropertyAddressState extends State<PropertyAddress> {
  // String state = '';
  final state = TextEditingController();
  final address = Address();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: kPadding,
      decoration: BoxDecoration(
        borderRadius: kBorderRadius,
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Strings.propertyAddress,
            style: context.textTheme.headline6?.copyWith(
              color: Colors.black,
            ),
          ),
          Gap(1.5.height),
          MyTextField(
            hintText: Strings.street,
            onChanged: (s) {
              address.street = s;
              widget.onChanged?.call(address);
            },
            // validator: ,
          ),
          Gap(0.5.height),
          MyTextField(
            hintText: Strings.town,
            onChanged: (s) {
              address.town = s;
              widget.onChanged?.call(address);
            },
          ),
          Gap(0.5.height),
          GestureDetector(
            onTap: () => BottomSheetService.showSheet(
              child: States(
                onChanged: (value) => setState(() {
                  state.text = value;
                  address.state = value;
                  widget.onChanged?.call(address);
                }),
              ),
            ),
            child: AbsorbPointer(
              child: MyTextField(
                // enabled: false,
                hintText: Strings.selectState,
                suffixIcon: Icon(Icons.keyboard_arrow_down),
                controller: state,
              ),
            ),
          ),
          Gap(0.5.height),
          MyTextField(
            hintText: Strings.postCode,
            maxLength: 4,
            validator: Validator.text,
            onChanged: (s) {
              final code = int.tryParse(s);
              if (code != null) {
                address.postcode = code;
                widget.onChanged?.call(address);
              }
              // address.postcode = int.tryParse(s);
              // widget.onChanged?.call(address);
              // widget.streetChanged?.call(s);
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
          ),
        ],
      ),
    );
  }
}
