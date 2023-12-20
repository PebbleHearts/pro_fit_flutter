class HistoryRecord {
  double weight;
  int reps;

  HistoryRecord(this.weight, this.reps);
}

class HistoryItemDataModel {
  String name;
  List<HistoryRecord> records;

  HistoryItemDataModel(this.name, this.records);
}
