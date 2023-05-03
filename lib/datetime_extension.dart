import 'package:intl/intl.dart';

extension DayOnly on DateTime {
  DateTime get dayOnly => DateTime(year, month, day);
  String get formatted => DateFormat('dd.MM.yyyy').format(this);
}
