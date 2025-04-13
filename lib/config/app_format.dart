import 'package:intl/intl.dart';

class AppFormat {
  static String justDate(DateTime dateTime) {
    return DateFormat('dd-mm-yyyy').format(dateTime);
  }

  static String shortDate(source) {
    switch (source.runtimeType) {
      case String:
        return DateFormat('d MMM yy').format(DateTime.parse(source));
      case DateTime:
        return DateFormat('d MMM yy').format(source);
      default:
        return 'not valid';
    }
  }
}
