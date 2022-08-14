import 'package:background_location/constants/index.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class PhoneTextField extends StatefulWidget {
  final void Function(String, String)? onChanged;
  final TextEditingController? controller;
  const PhoneTextField({Key? key, this.onChanged, this.controller}) : super(key: key);

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  CountryDetails? _countryDetails;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    await CountryCodes
        .init(); // Optionally, you may provide a `Locale` to get countrie's localizadName

    //  _deviceLocale = CountryCodes.getDeviceLocale();
    // print(deviceLocale?.languageCode); // Displays en
    // print(deviceLocale?.countryCode); // Displays US

    _countryDetails = CountryCodes.detailsForLocale();
    // _countryDetails.
    setState(() {});
    // print(details.alpha2Code); // Displays alpha2Code, for example US.
    // print(details.dialCode); // Displays the dial code, for example +1.
    // print(details.name); // Displays the extended name, for example United States.
    // print(details.localizedName); // Disp
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (_countryDetails?.dialCode != null)
          Flexible(
            flex: 1,
            child: IntlPhoneField(
              showCountryFlag: true,
              controller: widget.controller,
               inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
              decoration: InputDecoration(
                counter: SizedBox.shrink(),
                labelText: Strings.mobile,
                border: MyDecoration.inputBorder,
                contentPadding: kInputPadding,
              ),
              initialCountryCode: _countryDetails?.alpha2Code,
              // showDropdownIcon: false,
              onCountryChanged: (c) {
                print(c);
              },
              onChanged: (phone) {
                
                print(phone.completeNumber);
                if (widget.onChanged != null) widget.onChanged!(phone.number, phone.countryCode);
                // print('country code ${phone.countryCode}');
              },
            ),
          ),
        // if (_countryDetails?.dialCode != null) Gap(2.width),
        // Flexible(
        //   flex: _countryDetails?.dialCode == null ? 1 : 2,
        //   child: MyTextField(
        //     maxLength: 10,
        //     inputFormatters: [
        //       FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        //     ],
        //     onChanged: widget.onChanged,
        //     prefixIcon: Icon(Icons.phone),
        //     hintText: Strings.mobile,
        //     validator: Validator.mobileNo,
        //     controller: widget.controller,
        //   ),
        // ),
      ],
    );
  }
}
