import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/index.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../../constants/countries.dart';

class PhoneTextField extends StatefulWidget {
  final void Function(String, String)? onChanged;
  final TextEditingController? controller;
  const PhoneTextField({Key? key, this.onChanged, this.controller}) : super(key: key);

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  CountryDetails? _countryDetails;
  String? countryCode;

  @override
  void initState() {
    _getCountryCode();
    _init();

    super.initState();
  }

  Future<void> _init() async {
    await CountryCodes.init(); // Optionally, you may provide a `Locale` to get countrie's localizadName
    _countryDetails = CountryCodes.detailsForLocale();
    setState(() {});
  }

  void _getCountryCode() {
    final api = context.read<Api>();
    final user = api.getUser();
    if (user == null) return;
    if (user.countryCode == null) return;

    final country = countryList.where((element) => '+${element.phoneCode}'.compareTo(user.countryCode!) == 0);
    if (country.isEmpty) return;
    countryCode = country.first.isoCode;
  }

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      key: UniqueKey(),
      controller: widget.controller,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(
        // color: theme.iconTheme.color,
        fontWeight: FontWeight.bold,
        // color
      ),
      decoration: const InputDecoration(
        counter: SizedBox.shrink(),
        labelText: Strings.mobile,
        border: MyDecoration.inputBorder,
        contentPadding: kInputPadding,
        labelStyle: TextStyle(
          // color: theme.iconTheme.color,
          fontWeight: FontWeight.bold,
          // color
        ),
      ),
      initialCountryCode: countryCode ?? _countryDetails?.alpha2Code,
      // showDropdownIcon: false,
      onCountryChanged: print,
      onChanged: (phone) {
        print(phone.completeNumber);
        if (widget.onChanged != null) widget.onChanged!(phone.number, phone.countryCode);
        // print('country code ${phone.countryCode}');
      },
    );
  }
}
