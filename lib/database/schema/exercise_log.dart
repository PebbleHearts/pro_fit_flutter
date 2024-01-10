import 'package:drift/drift.dart';
import 'package:pro_fit_flutter/constants/common.dart';
import 'package:pro_fit_flutter/database/converters.dart';

class ExerciseLog extends Table {
  TextColumn get id => text().clientDefault(() => uuidInstance.v4())();
  TextColumn get logDate => text()();
  // TODO: Add a reference constraint for the category field
  TextColumn get exerciseId => text()();
  TextColumn get workoutRecords => text().map(const WorkoutRecordConverter())();
  TextColumn get description => text()();
  IntColumn get order => integer()();
}
