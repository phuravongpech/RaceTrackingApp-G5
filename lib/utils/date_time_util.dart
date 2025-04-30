class DateTimeUtil {
  // static String formatDateTime(
  //   DateTime dateTime, {
  //   String format = 'HH:mm:ss',
  // }) {
  //   return DateFormat(format).format(dateTime);
  // }

  // // static String formatDate(DateTime dateTime) {
  // //   return DateFormat('dd/MM/yyyy').format(dateTime);
  // // }

  static String formatMillisToHourMinSec(int milliseconds) {
    final hours = (milliseconds / (3600 * 1000)).floor();
    final minutes = ((milliseconds % (3600 * 1000)) / 60000).floor();
    final seconds = ((milliseconds % 60000) / 1000).floor();

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
