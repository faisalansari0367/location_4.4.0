// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:bioplus/ui/user_profile/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfilePage', () {
    group('route', () {
      test('is routable', () {
        expect(UserProfilePage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders UserProfileView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: UserProfilePage()));
      expect(find.byType(UserProfileView), findsOneWidget);
    });
  });
}
