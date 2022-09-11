// import 'package:country_codes/country_codes.dart';

// abstract class LocalesApi {
//   String? get countryCode;
//   String? get countryName;
//   // String? get currencyCode;
//   String? get dialCode;

//   // Future<void> initLocale();

//   void changeCountry({required String code, required String dial, required String name});
// }

// class LocalesRepo extends LocalesApi {
//   String? _countryCode;
//   String? _countryName;
//   // String? languageCode;
//   String? _dialCode;

//   @override
//   Future<void> initLocale() async {
//     await CountryCodes.init();
//     final countryDetails = CountryCodes.detailsForLocale();
//     _dialCode = countryDetails.alpha2Code;
//     _countryName = countryDetails.name;
//     _countryCode = countryDetails.name;
//   }

//   @override
//   void changeCountry({required String code, required String dial, required String name}) {
//     _countryCode = code;
//     _countryName = name;
//     _dialCode = dial;
//   }

//   @override
//   String? get countryCode => _countryCode;

//   @override
//   String? get countryName => _countryName;

//   // @override
//   // String? get currencyCode => _c;

//   @override
//   String? get dialCode => _dialCode;
// }
