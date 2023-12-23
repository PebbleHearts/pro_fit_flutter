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