import 'package:intl/intl.dart';

class MyDateFormat {
  static String formatDate(DateTime? date) =>
      date == null ? '' : DateFormat('dd-MM-yyyy').format(date);
  static String formatTime(DateTime? date) =>
      date == null ? '' : DateFormat('hh:mm:ss a').format(date);
  static String formatDateInYMMMED(DateTime? date) =>
      date == null ? '' : DateFormat.yMMMEd().format(date);
  static String formatDateWithTime(DateTime? dateTime) {
    return '${formatDate(dateTime)}  ${formatTime(dateTime)}';
  }

  static parseDate(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date)?.toLocal();
  }
}
