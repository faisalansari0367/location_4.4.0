// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:bioplus/ui/edec_forms/page/livestock_waybill/livestock_waybill.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LivestockWaybillBody', () {
    testWidgets('renders Text', (tester) async { 
      await tester.pumpWidget(
        Provider(
          create: (context) => ChangeNotifierProvider(create: (context) => LivestockWaybillNotifier(context)),
          child: MaterialApp(home: LivestockWaybillBody()),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
