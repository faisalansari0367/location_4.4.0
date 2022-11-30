// // ignore_for_file: prefer_const_constructors

// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:background_location/ui/sos_warning/cubit/cubit.dart';

// void main() {
//   group('SosWarningCubit', () {
//     group('constructor', () {
//       test('can be instantiated', () {
//         expect(
//           SosWarningCubit(),
//           isNotNull,
//         );
//       });
//     });

//     test('initial state has default value for customProperty', () {
//       final sosWarningCubit = SosWarningCubit();
//       expect(sosWarningCubit.state.customProperty, equals('Default Value'));
//     });

//     blocTest<SosWarningCubit, SosWarningState>(
//       'yourCustomFunction emits nothing',
//       build: SosWarningCubit.new,
//       act: (cubit) => cubit.yourCustomFunction(),
//       expect: () => <SosWarningState>[],
//     );
//   });
// }
