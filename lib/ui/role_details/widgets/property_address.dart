// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:background_location/constants/index.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/helpers/validator.dart';
import 'package:background_location/ui/role_details/widgets/states.dart';
import 'package:background_location/widgets/auto_spacing.dart';
import 'package:background_location/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../widgets/text_fields/focus_nodes/always_disabled_focus_node.dart';

class Address {
  String? postcode;
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
      // postcode: ![null, ''].contains(map['postcode']) ? map['postcode'] : null,
      postcode: map['postcode'],
      street: map['street'] != null ? map['street'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      town: map['town'] != null ? map['town'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) => Address.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PropertyAddress extends StatefulWidget {
  final bool showStreet, showTown, showState, showPostcode;
  final ValueChanged<Address>? onChanged;
  const PropertyAddress({
    Key? key,
    this.onChanged,
    this.showStreet = true,
    this.showTown = true,
    this.showState = true,
    this.showPostcode = true,
  }) : super(key: key);

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
          color: Colors.grey.shade400,
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
          AutoSpacing(
            spacing: Gap(0.5.height),
            children: [
              if (widget.showStreet)
                MyTextField(
                  hintText: Strings.street,
                  onChanged: (s) {
                    address.street = s;
                    widget.onChanged?.call(address);
                  },
                  validator: Validator.text,
                ),
              if (widget.showTown)
                MyTextField(
                  hintText: Strings.town,
                  validator: Validator.text,
                  onChanged: (s) {
                    address.town = s;
                    widget.onChanged?.call(address);
                  },
                ),
              if (widget.showState)
                MyTextField(
                  onTap: () => BottomSheetService.showSheet(
                    child: States(
                      onChanged: (value) => setState(() {
                        state.text = value;
                        address.state = value;
                        widget.onChanged?.call(address);
                      }),
                    ),
                  ),
                  enabled: true,
                  hintText: Strings.selectState,
                  suffixIcon: Icon(Icons.keyboard_arrow_down),
                  controller: state,
                  focusNode: AlwaysDisabledFocusNode(),
                  readOnly: false,
                ),
              if (widget.showPostcode)
                MyTextField(
                  hintText: Strings.postCode,
                  maxLength: 4,
                  validator: Validator.text,
                  onChanged: (s) {
                    // final code = int.tryParse(s);
                    // if (s != null) {
                    address.postcode = s;
                    widget.onChanged?.call(address);
                    // }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
