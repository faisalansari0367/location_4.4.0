// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:bioplus/ui/add_pic/add_pic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AddPicPage', () {
    group('route', () {
      test('is routable', () {
        expect(AddPicPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders AddPicView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: AddPicPage()));
      expect(find.byType(AddPicView), findsOneWidget);
    });
  });
}
