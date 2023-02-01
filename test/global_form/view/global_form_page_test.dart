// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:bioplus/ui/forms/global_form/global_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlobalFormPage', () {
    group('route', () {
      test('is routable', () {
        expect(GlobalFormPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders GlobalFormView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: GlobalFormPage()));
      expect(find.byType(GlobalFormView), findsOneWidget);
    });
  });
}
