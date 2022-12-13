// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:bioplus/ui/edec_forms/page/livestock_waybill/livestock_waybill.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LivestockWaybillPage', () {
    group('route', () {
      test('is routable', () {
        expect(LivestockWaybillPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders LivestockWaybillView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: LivestockWaybillPage()));
      expect(find.byType(LivestockWaybillView), findsOneWidget);
    });
  });
}
