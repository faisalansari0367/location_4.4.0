import 'package:intl/intl.dart';

class MyDateFormat {
  static String formatDate(DateTime? date) {
    return date == null ? '' : DateFormat('dd-MM-yyyy').format(date);
  }

  static String formatTime(DateTime? date) {
    return date == null ? '' : DateFormat('hh:mm:ss a').format(date);
  }

  static String formatDateInYMMMED(DateTime? date) {
    return date == null ? '' : DateFormat.yMMMEd().format(date);
  }

  static String formatDateWithTime(DateTime? dateTime) {
    return '${formatDate(dateTime)}  ${formatTime(dateTime)}';
  }

  // static String _parseDt(DateTime? dt, [String? format = 'dd-MM-yyyy']) {
  //   if (dt == null) return '';
  //   return DateFormat(dt.year, dt.month, dt.day);

  // }

  static parseDate(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date)?.toLocal();
  }
}
