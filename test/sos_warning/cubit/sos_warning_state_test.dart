// ignore_for_file: prefer_const_constructors

import 'package:bioplus/ui/sos_warning/cubit/cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SosWarningState', () {
    test('supports value equality', () {
      expect(
        SosWarningState(),
        equals(
          const SosWarningState(),
        ),
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(
          const SosWarningState(),
          isNotNull,
        );
      });
    });

    group('copyWith', () {
      test(
        'copies correctly '
        'when no argument specified',
        () {
          const sosWarningState = SosWarningState(
            customProperty: 'My property',
          );
          expect(
            sosWarningState.copyWith(),
            equals(sosWarningState),
          );
        },
      );

      test(
        'copies correctly '
        'when all arguments specified',
        () {
          const sosWarningState = SosWarningState(
            customProperty: 'My property',
          );
          final otherSosWarningState = SosWarningState(
            customProperty: 'My property 2',
          );
          expect(sosWarningState, isNot(equals(otherSosWarningState)));

          expect(
            sosWarningState.copyWith(
              customProperty: otherSosWarningState.customProperty,
            ),
            equals(otherSosWarningState),
          );
        },
      );
    });
  });
}
