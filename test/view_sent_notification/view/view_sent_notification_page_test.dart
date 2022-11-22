// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:background_location/view_sent_notification/view_sent_notification.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ViewSentNotificationPage', () {
    group('route', () {
      test('is routable', () {
        expect(ViewSentNotificationPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders ViewSentNotificationView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: ViewSentNotificationPage()));
      expect(find.byType(ViewSentNotificationView), findsOneWidget);
    });
  });
}
