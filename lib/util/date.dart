import 'package:intl/intl.dart';

List<DateTime> getNext30Days(
    {required DateTime fromDate, bool includeFromDate = false}) {
  List<DateTime> next30Days = [];
  final firstIndex = includeFromDate ? 0 : 1;
  final lastIndex = includeFromDate ? 29 : 30;
  for (int i = firstIndex; i <= lastIndex; i++) {
    next30Days.add(fromDate.add(Duration(days: i)));
  }
  return next30Days.reversed.toList();
}

List<DateTime> getPrevious30Days(
    {required DateTime fromDate, bool includeFromDate = false}) {
  List<DateTime> previous30Days = [];
  final lastIndex = includeFromDate ? 0 : 1;
  final firstIndex = includeFromDate ? 29 : 30;
  for (int i = firstIndex; i >= lastIndex; i--) {
    previous30Days.add(fromDate.subtract(Duration(days: i)));
  }
  return previous30Days.reversed.toList();
}

String getHorizontalListDateMonthLabel(DateTime startDate, DateTime endDate) {
  final String year1 = DateFormat('yyyy').format(startDate);
  final String year2 = DateFormat('yyyy').format(endDate);
  final String month1 = DateFormat('MMM').format(startDate);
  final String month2 =DateFormat('MMM').format(endDate);

  if (year1 != year2) {
    return '$year2 $month2 / $year1 $month1';
  } else if (month1 != month2) {
    return '$year1 $month2/$month1';
  } else {
    return '$year1 $month1';
  }
}