// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:bioplus/ui/forms/global_form/cubit/cubit.dart';

void main() {
  group('GlobalFormState', () {
    test('supports value equality', () {
      expect(
        GlobalFormState(),
        equals(
          const GlobalFormState(),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const GlobalFormState(),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const globalFormState = GlobalFormState(
            customProperty: 'My property',
          );
          expect(
            globalFormState.copyWith(),
            equals(globalFormState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const globalFormState = GlobalFormState(
            customProperty: 'My property',
          );
          final otherGlobalFormState = GlobalFormState(
            customProperty: 'My property 2',
          );
          expect(globalFormState, isNot(equals(otherGlobalFormState)));

          expect(
            globalFormState.copyWith(
              customProperty: otherGlobalFormState.customProperty,
            ),
            equals(otherGlobalFormState),
          );
        },
      );
    });
  });
}
