import 'package:intl/intl.dart';

class AppFormat {
  static String justDate(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static String shortDate(source) {
    switch (source.runtimeType) {
      case String _:
        return DateFormat('d MMM yy').format(DateTime.parse(source));
      case DateTime _:
        return DateFormat('d MMM yy').format(source);
      default:
        return 'not valid';
    }
  }
}
