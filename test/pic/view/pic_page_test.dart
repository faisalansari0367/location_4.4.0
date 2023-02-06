// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:bioplus/ui/PIC/pic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PicPage', () {
    group('route', () {
      test('is routable', () {
        expect(PicPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders PicView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: PicPage()));
      expect(find.byType(PicView), findsOneWidget);
    });
  });
}
