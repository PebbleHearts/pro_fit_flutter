import 'package:flutter/material.dart';
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

class RoutineDetailItemWithExercise {
  RoutineDetailItemWithExercise(
    this.routineDetailItem,
    this.exercise,
  );

  final RoutineDetailItemData routineDetailItem;
  final ExerciseData? exercise;
}

class CustomBottomTabItem {
  IconData icon;
  String label;

  CustomBottomTabItem({
    required this.icon,
    required this.label,
  });
}
