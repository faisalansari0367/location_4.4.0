// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:background_location/ui/sos_warning/sos_warning.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SosWarningPage', () {
    group('route', () {
      test('is routable', () {
        expect(SosWarningPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders SosWarningView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: SosWarningPage()));
      expect(find.byType(SosWarningView), findsOneWidget);
    });
  });
}
