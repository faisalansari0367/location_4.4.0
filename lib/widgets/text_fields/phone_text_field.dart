import 'package:api_repo/api_repo.dart';
import 'package:bioplus/constants/countries.dart';
import 'package:bioplus/constants/index.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class PhoneTextField extends StatefulWidget {
  final String? hintText, initialValue;
  final ValueChanged<String>? onCountryChanged;
  final void Function(String number, String countryCode)? onChanged;
  final TextEditingController? controller;
  const PhoneTextField({
    super.key,
    this.onChanged,
    this.hintText,
    this.controller,
    this.onCountryChanged,
    this.initialValue,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  CountryDetails? _countryDetails;
  String? countryCode;

  @override
  void initState() {
    _init();

    super.initState();
  }

  Future<void> _init() async {
    await CountryCodes.init();
    _countryDetails = CountryCodes.detailsForLocale();
    _getCountryCode();
    setState(() {});
  }

  void _getCountryCode() {
    final api = context.read<Api>();
    final user = api.getUserData();
    if (user == null || !api.isLoggedIn) return;
    if (user.countryCode == null) return;

    final country = countryList.where(
      (element) => '+${element.phoneCode}'.compareTo(user.countryCode!) == 0,
    );
    if (country.isEmpty) return;
    if (country.length > 1) {
      if (user.countryOfResidency != null) {
        final finalCountry = country.where(
          (element) =>
              element.name.toLowerCase() ==
              user.countryOfResidency!.toLowerCase(),
        );
        if (finalCountry.isEmpty) return;
        countryCode = finalCountry.first.isoCode;

        return;
      }
    }
    countryCode = country.first.isoCode;
  }

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      key: UniqueKey(),
      initialValue: widget.initialValue,
      controller: widget.controller,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      decoration: MyDecoration.stadiumInputDecoration(context).copyWith(
        counter: const SizedBox.shrink(),
        labelText: widget.hintText ?? Strings.mobile,
        border: MyDecoration.inputBorder,
        contentPadding: kInputPadding,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      initialCountryCode: countryCode ?? _countryDetails?.alpha2Code,
      onCountryChanged: print,
      onChanged: (phone) {
        widget.onChanged?.call(phone.number, phone.countryCode);

        final countries = countryList
            .where((element) => element.isoCode == phone.countryISOCode)
            .toList();
        if (countries.isEmpty) return;
        final country = countries.first;

        if (widget.onCountryChanged != null) {
          widget.onCountryChanged?.call(country.name);
        }
      },
    );
  }

  Country? getCountryByName(String countryName) {
    final countries = countryList
        .where(
          (element) => element.name.toLowerCase() == countryName.toLowerCase(),
        )
        .toList();
    if (countries.isEmpty) return null;
    final country = countries.first;
    return country;
  }
}
