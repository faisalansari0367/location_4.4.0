// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:background_location/ui/forms/global_questionnaire_form/global_questionnaire_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlobalQuestionnaireFormBody', () {
    testWidgets('renders Text', (tester) async { 
      await tester.pumpWidget(
        Provider(
          create: (context) => ChangeNotifierProvider(create: (_) => GlobalQuestionnaireFormNotifier()),
          child: MaterialApp(home: GlobalQuestionnaireFormBody()),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
