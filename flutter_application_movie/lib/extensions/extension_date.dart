import 'package:intl/intl.dart';

class ExtensionDate {
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }
}
