import 'package:api_repo/api_repo.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:background_location/widgets/text_fields/focus_nodes/always_disabled_focus_node.dart';
import 'package:background_location/widgets/text_fields/text_formatters/input_formatters.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../constants/countries.dart';

class CountryField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onCountryChanged;
  final String? countryName;
  final String? label;
  final bool isOriginCountry, showCity;
  const CountryField({
    Key? key,
    required this.onCountryChanged,
    this.countryName,
    this.label,
    this.controller,
    this.isOriginCountry = false,
    this.showCity = false,
  }) : super(key: key);

  @override
  State<CountryField> createState() => _CountryFieldState();
}

class _CountryFieldState extends State<CountryField> {
  // final controller = TextEditingController();
  Country? country;

  @override
  initState() {
    if (widget.isOriginCountry) {
      _getCountryFromCode();
      // WidgetsBinding.instance?.addPersistentFrameCallback((_) async {
      //   // await CountryCodes.init(); // Optionally, you may provide a `Locale` to get countrie's localizadName

      //   // final _countryDetails = CountryCodes.detailsForLocale();
      //   // _countryDetails.dialCode;
      // });
    } else
      _getCountryFromName();
    super.initState();
  }

  void _getCountryFromName() {
    country = ![null, ''].contains(widget.countryName) ? countryList.firstWhere(sameCountryName) : null;
    // if(country != null) widget.controller?.text = country!.name;
  }

  void _getCountryFromCode({String? countryCode}) {
    if (widget.isOriginCountry) {
      final user = context.read<Api>().getUser();
      final foundCountry =
          countryList.where((country) => sameCountryCode(country, countryCode ?? user?.countryCode)).toList();
      if (foundCountry.isNotEmpty) {
        country = foundCountry.first;
        widget.controller?.text = country!.name.toUpperCase();
        widget.onCountryChanged.call(country!.name.toUpperCase());
      }
    }
  }

  @override
  didUpdateWidget(CountryField oldWidget) {
    if (oldWidget.countryName != widget.countryName) {
      _getCountryFromName();
    } else {
      _getCountryFromCode();
    }
    super.didUpdateWidget(oldWidget);
  }

  bool sameCountryCode(Country country, String? countryCode) {
    if (countryCode == null) return false;
    final hasPlus = countryCode.startsWith('+');
    final countryCodeWithoutPlus = hasPlus ? countryCode.substring(1) : countryCode;
    return country.phoneCode.toLowerCase() == countryCodeWithoutPlus.toLowerCase();
  }

  bool sameCountryName(Country country) {
    return country.name.toLowerCase() == widget.countryName!.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: MyTextField(
            focusNode: AlwaysDisabledFocusNode(),
            // inputFormatters: [CapitalizeAllInputFormatter()],
            onTap: showCountrySheet,
            enabled: true,
            controller: widget.controller,
            hintText: widget.label ?? 'Please select a country',
            suffixIcon: Icon(Icons.arrow_drop_down),
            prefixIcon: _prefixIcon(),
          ),
        ),
        if (!widget.isOriginCountry) Gap(2.width),
        if (widget.showCity)
          Expanded(
            child: MyTextField(
              hintText: 'City',
              inputFormatters: [CapitalizeAllInputFormatter()],
            ),
          ),
      ],
    );
  }

  Widget? _prefixIcon() {
    if (country == null) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(20.w),
        Image.asset(
          country!.flag,
          width: 32.sp,
        ),
        Gap(4.width),
      ],
    );
  }

  void showCountrySheet() {
    BottomSheetService.showSheet(
      child: CountrySelection(
        onCountryChanged: (country) {
          setState(() {
            this.country = country;
            widget.controller?.text = country.name.toUpperCase();
          });
        },
      ),
    );
  }
}

class CountrySelection extends StatefulWidget {
  // FUNCITON TO CHANGE COUNTRY
  final ValueChanged<Country> onCountryChanged;
  const CountrySelection({Key? key, required this.onCountryChanged}) : super(key: key);

  @override
  State<CountrySelection> createState() => _CountrySelectionState();
}

class _CountrySelectionState extends State<CountrySelection> {
  String _selectedCountry = '';
  final controller = TextEditingController();

  @override
  void initState() {
    controller.addListener(() {
      onChanged(controller.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Column(
          children: [
            // divider
            Gap(2.height),
            MyTextField(
              hintText: 'Type here to search country',
              autovalidateMode: AutovalidateMode.disabled,
              // onChanged: onChanged,
              controller: controller,
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _filteredList.length,
                itemBuilder: (context, index) {
                  final country = _filteredList[index];
                  return ListTile(
                    title: Text(country.name),
                    leading: Image.asset(
                      country.flag,
                      width: 30,
                    ),
                    onTap: () {
                      widget.onCountryChanged.call(country);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<Country> get _filteredList {
    if (_selectedCountry.isEmpty) return countryList;
    return countryList.where((element) => element.name.toLowerCase().contains(_selectedCountry.toLowerCase())).toList();
  }

  void onChanged(String p1) {
    if (p1.isEmpty) return;
    setState(() {
      _selectedCountry = p1;
    });
  }
}
