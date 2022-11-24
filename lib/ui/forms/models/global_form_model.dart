// ignore_for_file: public_member_api_docs, sort_constructors_first
class GlobalFormModel {
  final bool? isPeopleTravelingWith,
      isQFeverVaccinated,
      isFluSymptomps,
      isOverseasVisit,
      isAllMeasureTaken,
      isOwnerNotified;

  final String rego, riskRating, signature;

  final DateTime expectedDepartureDate, expectedDepartureTime;

  final List<String> usersTravellingAlong;

  _Keys get keys => _Keys();

  Map<String, dynamic> get _questions {
    final questions = {
      'isPeopleTravelingWith': '1. Are other people travelling onto the property with you?',
      'userTravelingAlong': [],
      'isQfeverVaccinated': '2. Have all visitors had a Q Fever vaccination?',
      'isFluSymptoms': '3. Do you have cold or flu symptoms?',
      'isOverSeaVisit': '4. Have any visitors been overseas in the last 7 days?',
      'isAllMeasureTaken':
          '5. Have you taken all reasonable measures to ensure that shoes, clothing and equipment are free from potential weed and disease contaminants:',
      'isOwnerNotified':
          '6. Have you made reasonable attempts to notify the owner/manager of the property that you are visiting today?',
      'rego': 'Rego',
      'selfDeclaration':
          'I declare that any animals/products I am transporting are accompanied by correct movement documentation.',
      'riskRating': 'Risk Rating',
      'expectedDepartureTime': 'Expected Departure Time',
      'expectedDepartureDate': 'Expected Departure Date',
      'signature': 'Signature',
    };
    return questions;
  }

  String question(String key) => _questions[key] ?? '';

  GlobalFormModel({
    required this.signature,
    required this.expectedDepartureDate,
    required this.expectedDepartureTime,
    required this.rego,
    this.usersTravellingAlong = const [],
    this.isOwnerNotified,
    this.isAllMeasureTaken,
    this.isOverseasVisit,
    required this.riskRating,
    this.isFluSymptomps,
    this.isQFeverVaccinated,
    this.isPeopleTravelingWith,
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'isPeopleTravelingWith': isPeopleTravelingWith,
      'userTravelingAlong': usersTravellingAlong,
      'isQfeverVaccinated': isQFeverVaccinated,
      'isFluSymptoms': isFluSymptomps,
      'isOverSeaVisit': isOverseasVisit,
      'isAllMeasureTaken': isAllMeasureTaken,
      'isOwnerNotified': isOwnerNotified,
      'rego': rego,
      'riskRating': riskRating,
      'expectedDepartureTime': expectedDepartureTime.toIso8601String(),
      'expectedDepartureDate': expectedDepartureDate.toIso8601String(),
      'signature': signature,
    };
  }
}

class _Keys {
  _Keys();
  final isPeopleTravelingWith = 'isPeopleTravelingWith';
  final userTravelingAlong = 'userTravelingAlong';
  final isQfeverVaccinated = 'isQfeverVaccinated';
  final isFluSymptoms = 'isFluSymptoms';
  final isOverSeaVisit = 'isOverSeaVisit';
  final isAllMeasureTaken = 'isAllMeasureTaken';
  final isOwnerNotified = 'isOwnerNotified';
  final rego = 'rego';
  final riskRating = 'riskRating';
  final expectedDepartureTime = 'expectedDepartureTime';
  final expectedDepartureDate = 'expectedDepartureDate';
  final signature = 'signature';
}
