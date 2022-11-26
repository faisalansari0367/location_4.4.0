class WarakirriQuestionFormModel {
  WarakirriQuestionFormModel();
  final isPeopleTravelingWith = 'isPeopleTravelingWith',
      userTravelingAlong = 'userTravelingAlong',
      isFluSymptoms = 'isFluSymptoms',
      isOverSeaVisit = 'isOverSeaVisit',
      expectedDepartureDate = 'expectedDepartureDate',
      hasBeenInducted = 'hasBeenInducted',
      isConfinedSpace = 'isConfinedSpace',
      warakirriFarm = 'warakirriFarm',
      additionalInfo = 'additionalInfo';

  Map<String, dynamic> get _questions => {
        warakirriFarm: 'Name of warrakirri farm',
        isPeopleTravelingWith: '1. Are other people travelling onto the property with you?',
        isFluSymptoms:
            '2. Do you have any of the following symptoms: feeling unwell or displaying any flu-like symptoms, sudden loss of smell or taste, fever, cough, sore throat, fatigue or shortness of breath?',
        isOverSeaVisit: '3. Have you been overseas in the past 7 days ?',
        hasBeenInducted: '4. Have you been inducted to this site ',
        isConfinedSpace:
            '5. Does the work being undertaken involve exposure to Confined Spaces,  Native Vegetation Clearing, Work at Heights or Firearm Use. Are you working on any plant that needs to be isolated?',
        expectedDepartureDate: 'What is your expected departure time?',
      };

  String question(String key) => _questions[key] ?? '';
}
