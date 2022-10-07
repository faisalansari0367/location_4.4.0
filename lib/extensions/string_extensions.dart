import 'package:get/get.dart';

extension StringExt on String {
  String get toCamelCase {
    var string = '';
    final result = trim().split(' ');
    // print(result);
    for (final word in result) {
      final cap = word.capitalize!;
      string += cap;
    }
    return string.replaceFirst(string[0], string[0].toLowerCase());
  }
}
