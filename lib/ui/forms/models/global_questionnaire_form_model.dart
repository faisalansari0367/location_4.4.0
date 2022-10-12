import 'package:background_location/ui/forms/cubit/forms_cubit_cubit.dart';

class GlobalQuestionnaireFormModel {
  // {
  //           "field": "Have you made reasonable attempts to notify the owner/manager of the property that you are visiting today?",
  //           "value": null
  //       },
  //       {
  //           "field": "Are you Covid free?",
  //           "value": null
  //       },
  //       {
  //           "field": "Have you taken all reasonable measures to ensure that shoes, clothing and equipment are free from potential weed and disease contaminants:",
  //           "value": null
  //       },
  //       {
  //           "field": "Have any been overseas in the last 7 days?",
  //           "value": null
  //       }

  final q1 = QuestionData(
      question:
          'Have you made reasonable attempts to notify the owner/manager of the property that you are visiting today?');
  final q2 = QuestionData(question: 'Are you Covid free?');
  final q3 = QuestionData(
      question:
          'Have you taken all reasonable measures to ensure that shoes, clothing and equipment are free from potential weed and disease contaminants:');
  final q4 = QuestionData(question: 'Have any been overseas in the last 7 days?');
  final q5 = QuestionData(question: 'Are other people traveling onto the property with you?');
  final selfDeclaration = QuestionData(
    question:
        'I declare that the animals/products I am transporting are accompanied by correct movement documentation.',
  );
  final riskRating = QuestionData(question: 'Risk Rating', value: 'Low');
  final expectedDepartureDate =
      QuestionData(question: 'Expected departure date', value: DateTime.now().toIso8601String());
  final expectedDepartureTime =
      QuestionData(question: 'Expected departure time', value: DateTime.now().toIso8601String());
  final signature = QuestionData(question: 'Signature');

  List<Map<String, dynamic>> toJson() {
    return [
      q1.toJson(),
      q2.toJson(),
      q3.toJson(),
      q4.toJson(),
      q5.toJson(),
      riskRating.toJson(),
      expectedDepartureDate.toJson(),
      expectedDepartureTime.toJson(),
      signature.toJson(),
    ];
  }
}
