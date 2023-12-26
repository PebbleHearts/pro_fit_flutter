import 'package:pro_fit_flutter/database/database.dart';

final database = AppDatabase();

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


class ExerciseLogWithExercise {
  ExerciseLogWithExercise(this.workoutLog, this.exercise);

  final ExerciseLogData workoutLog;
  final ExerciseData? exercise;
}