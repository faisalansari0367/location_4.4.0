import 'package:get/get.dart';

extension StringExt on String {
  String get toCamelCase {
    String string = '';
    final result = this.trim().split(' ');
    // print(result);
    for (var word in result) {
      final cap = word.capitalize!;
      string += cap;
    }
    return string.replaceFirst(string[0], string[0].toLowerCase());
  }
}
