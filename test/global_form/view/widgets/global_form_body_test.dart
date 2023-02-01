// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:bioplus/ui/forms/global_form/global_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlobalFormBody', () {
    testWidgets('renders Text', (tester) async { 
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => GlobalFormCubit(),
          child: MaterialApp(home: GlobalFormBody()),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
