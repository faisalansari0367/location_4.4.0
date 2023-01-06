// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:bioplus/ui/geofence_delegation/geofence_delegation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeofenceDelegationPage', () {
    group('route', () {
      test('is routable', () {
        expect(GeofenceDelegationPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders GeofenceDelegationView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: GeofenceDelegationPage()));
      expect(find.byType(GeofenceDelegationView), findsOneWidget);
    });
  });
}
