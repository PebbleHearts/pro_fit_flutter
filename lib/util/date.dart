List<DateTime> getNext30Days({required DateTime fromDate,  bool includeFromDate = false}) {
  List<DateTime> next30Days = [];
  if (includeFromDate) {
    next30Days.add(fromDate);
  }
  for (int i = 0; i < 30; i++) {
    next30Days.add(fromDate.add(Duration(days: i)));
  }
  return next30Days;
}

List<DateTime> getPrevious30Days({required DateTime fromDate, bool includeFromDate = false}) {
  List<DateTime> previous30Days = [];
  if (includeFromDate) {
    previous30Days.add(fromDate);
  }
  for (int i = 29; i >= 0; i--) {
    previous30Days.add(fromDate.subtract(Duration(days: i)));
  }
  return previous30Days.reversed.toList();
}