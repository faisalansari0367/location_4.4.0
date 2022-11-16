import 'package:background_location/ui/forms/cubit/forms_cubit_cubit.dart';

class GlobalQuestionnaireFormModel {
  final q1 = QuestionData(
    question: '1. Are other people travelling onto the property with you?',
  );
  final q2 = QuestionData(
    question: '2. Have all visitors had a Q Fever vaccination?',
  );
  final q3 = QuestionData(
    question: '3. Do you have cold or flu symptoms?',
  );
  final q4 = QuestionData(
    question: '4. Have any visitors been overseas in the last 7 days?',
  );
  final q5 = QuestionData(
    question:
        '5. Have you taken all reasonable measures to ensure that shoes, clothing and equipment are free from potential weed and disease contaminants:',
  );
  final q6 = QuestionData(
    question:
        '6. Have you made reasonable attempts to notify the owner/manager of the property that you are visiting today?',
  );
  final rego = QuestionData(question: 'Rego');
  final selfDeclaration = QuestionData(
    question:
        'I declare that any animals/products I am transporting are accompanied by correct movement documentation.',
  );
  final riskRating = QuestionData(
    question: 'Risk Rating',
    value: 'Low',
  );
  final expectedDepartureDate = QuestionData(
    question: 'Expected departure date',
    value: DateTime.now().toIso8601String(),
  );
  final expectedDepartureTime = QuestionData(
    question: 'Expected departure time',
    value: DateTime.now().toIso8601String(),
  );
  final signature = QuestionData(
    question: 'Signature',
  );

  List<Map<String, dynamic>> toJson() {
    return [
      q1.toJson(),
      q2.toJson(),
      q3.toJson(),
      q4.toJson(),
      q5.toJson(),
      q6.toJson(),
      rego.toJson(),
      riskRating.toJson(),
      expectedDepartureDate.toJson(),
      expectedDepartureTime.toJson(),
      signature.toJson(),
    ];
  }
}
