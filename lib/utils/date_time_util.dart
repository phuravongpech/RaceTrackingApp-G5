import 'package:intl/intl.dart';

class DateTimeUtil {
  static String formatDateTime(
    DateTime dateTime, {
    String format = 'HH:mm:ss',
  }) {
    return DateFormat(format).format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }
}
