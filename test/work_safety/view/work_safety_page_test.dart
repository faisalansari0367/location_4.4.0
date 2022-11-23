// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:background_location/ui/work_safety/work_safety.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkSafetyPage', () {
    group('route', () {
      test('is routable', () {
        expect(WorkSafetyPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders WorkSafetyView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: WorkSafetyPage()));
      expect(find.byType(WorkSafetyView), findsOneWidget);
    });
  });
}
