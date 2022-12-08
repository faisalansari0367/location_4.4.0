// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bioplus/constants/index.dart';
import 'package:bioplus/helpers/validator.dart';
import 'package:bioplus/ui/role_details/widgets/states.dart';
import 'package:bioplus/widgets/auto_spacing.dart';
import 'package:bioplus/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:bioplus/widgets/text_fields/text_formatters/input_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/text_fields/focus_nodes/always_disabled_focus_node.dart';

class Address {
  String? postcode;
  String? street;
  String? state;
  String? town;
  Map<String, bool>? fieldsToShow;

  Address({
    this.postcode,
    this.street,
    this.state,
    this.town,
    this.fieldsToShow,
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
      postcode: map['postcode'] != null ? map['postcode'].toString() : null,
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
  final Address? address;
  final String? title;
  final ValueChanged<Address>? onChanged;

  const PropertyAddress({
    Key? key,
    this.onChanged,
    this.showStreet = true,
    this.showTown = true,
    this.showState = true,
    this.showPostcode = true,
    this.address,
    this.title,
  }) : super(key: key);

  @override
  State<PropertyAddress> createState() => _PropertyAddressState();
}

class _PropertyAddressState extends State<PropertyAddress> {
  final controllers = <String, TextEditingController>{};

  // final address = Address();
  late Address address;

  @override
  void initState() {
    address = widget.address ?? Address();
    address.toMap().forEach((key, value) {
      controllers[key] = TextEditingController(text: value as String?);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PropertyAddress oldWidget) {
    if (oldWidget.address != widget.address) {
      address = widget.address ?? Address();
      address.toMap().forEach((key, value) {
        controllers[key] = TextEditingController(text: value as String?);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = controllers['state']!;
    final postcode = controllers['postcode']!;
    final street = controllers['street']!;
    final town = controllers['town']!;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: kPadding,
      decoration: BoxDecoration(
        borderRadius: kBorderRadius,
        border: Border.all(
          color: Colors.grey.shade400,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title ?? Strings.propertyAddress,
            style: context.textTheme.headline6?.copyWith(
              color: Colors.black,
            ),
          ),
          Gap(1.5.height),
          AutoSpacing(
            spacing: Gap(1.height),
            children: [
              if (address.fieldsToShow?['street'] ?? false)
                MyTextField(
                  inputFormatters: [CapitalizeAllInputFormatter()],
                  hintText: Strings.street,
                  controller: street,
                  onChanged: (s) {
                    address.street = s;
                    widget.onChanged?.call(address);
                  },
                  validator: Validator.text,
                ),
              if (address.fieldsToShow?['town'] ?? false)
                MyTextField(
                  inputFormatters: [CapitalizeAllInputFormatter()],
                  hintText: Strings.town,
                  validator: Validator.text,
                  controller: town,
                  onChanged: (s) {
                    address.town = s;
                    widget.onChanged?.call(address);
                  },
                ),
              if (address.fieldsToShow?['state'] ?? false)
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
                  inputFormatters: [CapitalizeAllInputFormatter()],
                  hintText: Strings.selectState,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  controller: state,
                  focusNode: AlwaysDisabledFocusNode(),
                ),
              if (address.fieldsToShow?['postcode'] ?? false)
                MyTextField(
                  // inputFormatters: [CapitalizeAllInputFormatter()],

                  hintText: Strings.postCode,
                  maxLength: 4,
                  validator: Validator.postcode,
                  textInputType: TextInputType.number,
                  onChanged: (s) {
                    // final code = int.tryParse(s);
                    // if (s != null) {
                    address.postcode = s;
                    widget.onChanged?.call(address);
                    // }
                  },
                  controller: postcode,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
