// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:background_location/ui/forms/global_questionnaire_form/global_questionnaire_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlobalQuestionnaireFormPage', () {
    group('route', () {
      test('is routable', () {
        expect(GlobalQuestionnaireFormPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders GlobalQuestionnaireFormView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: GlobalQuestionnaireFormPage()));
      expect(find.byType(GlobalQuestionnaireFormView), findsOneWidget);
    });
  });
}
