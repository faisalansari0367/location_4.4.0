import 'package:api_repo/api_repo.dart';
import 'package:background_location/constants/countries.dart';
import 'package:background_location/extensions/size_config.dart';
import 'package:background_location/widgets/bottom_sheet/bottom_sheet_service.dart';
import 'package:background_location/widgets/text_fields/focus_nodes/always_disabled_focus_node.dart';
import 'package:background_location/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class CountryField extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onCountryChanged;
  final String? countryName;
  final String? label;
  final bool isOriginCountry;
  const CountryField({
    Key? key,
    required this.onCountryChanged,
    this.countryName,
    this.label,
    this.controller,
    this.isOriginCountry = false,
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
      final user = context.read<AuthRepo>().getUser();
      country = countryList.firstWhere((country) => sameCountryCode(country, user!.countryCode!));
    }
    country = widget.countryName != null ? countryList.firstWhere(sameCountryName) : null;
    super.initState();
  }

  bool sameCountryCode(Country country, String countryCode) {
    final hasPlus = countryCode.startsWith('+');
    final countryCodeWithoutPlus = hasPlus ? countryCode.substring(1) : countryCode;
    return country.phoneCode.toLowerCase() == countryCodeWithoutPlus.toLowerCase();
  }

  bool sameCountryName(Country country) {
    return country.name.toLowerCase() == widget.countryName!.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      focusNode: AlwaysDisabledFocusNode(),
      onTap: showCountrySheet,
      enabled: true,
      controller: widget.controller,
      hintText: widget.label ?? 'Please select a country',
      suffixIcon: Icon(Icons.arrow_drop_down),
      prefixIcon: _prefixIcon(),
    );
  }

  Widget? _prefixIcon() {
    if (country == null) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(5.width),
        Image.asset(
          'assets/countries/${country!.isoCode.toLowerCase()}.png',
          width: 8.width,
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
            widget.controller?.text = country.name;
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
                      'assets/countries/${country.isoCode.toLowerCase()}.png',
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
