import 'package:background_location/ui/forms/cubit/forms_cubit_cubit.dart';
import 'package:flutter/material.dart';

class GlobalQuestionnaireFormNotifier with ChangeNotifier {}

class FormQuestionDataModel {
  // final QuestionData isPeopleTravelingWith;



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



}
