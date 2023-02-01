// // ignore_for_file: prefer_const_constructors

// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:bioplus/ui/forms/global_form/cubit/cubit.dart';

// void main() {
//   group('GlobalFormCubit', () {
//     group('constructor', () {
//       test('can be instantiated', () {
//         expect(
//           GlobalFormCubit(),
//           isNotNull,
//         );
//       });
//     });

//     test('initial state has default value for customProperty', () {
//       final globalFormCubit = GlobalFormCubit();
//       expect(globalFormCubit.state.customProperty, equals('Default Value'));
//     });

//     blocTest<GlobalFormCubit, GlobalFormState>(
//       'yourCustomFunction emits nothing',
//       build: GlobalFormCubit.new,
//       act: (cubit) => cubit.yourCustomFunction(),
//       expect: () => <GlobalFormState>[],
//     );
//   });
// }
