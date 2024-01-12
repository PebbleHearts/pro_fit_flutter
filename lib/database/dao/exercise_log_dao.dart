import 'package:drift/drift.dart';
import 'package:pro_fit_flutter/data-model/common.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:pro_fit_flutter/database/schema/exercise.dart';
import 'package:pro_fit_flutter/database/schema/exercise_log.dart';

part 'exercise_log_dao.g.dart';

@DriftAccessor(tables: [ExerciseLog, Exercise])
class ExerciseLogDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseLogDaoMixin {
  ExerciseLogDao(AppDatabase db) : super(db);

  void insertExerciseLogRow(
    ExerciseLogCompanion companionData,
  ) async {
    await into(exerciseLog).insert(companionData);
  }

  Future<List<ExerciseLogData>> getAllExercisesLog() async {
    final query = select(exerciseLog);
    List<ExerciseLogData> allExerciseLogItems =
        await query.map((row) => row).get();
    return allExerciseLogItems;
  }

  Future<List<ExerciseLogWithExercise>> getDayLogWithExerciseDetails(
      String selectedDate) async {
    final query = select(exerciseLog).join([
      drift.innerJoin(
          database.exercise, exerciseLog.exerciseId.equalsExp(exercise.id)),
    ])
      ..where(
        exerciseLog.logDate.equals(selectedDate),
      );
    return query.map((row) {
      return ExerciseLogWithExercise(
          row.readTable(exerciseLog), row.readTable(exercise));
    }).get();
  }

  void updateExerciseLog(
      ExerciseLogCompanion exerciseLogCompanion, String exerciseLogId) {
    (database.update(database.exerciseLog)
          ..where(
            (t) => t.id.equals(exerciseLogId),
          ))
        .write(
      exerciseLogCompanion,
    );
  }

  void deleteExerciseLogItem(String exerciseLogId) {
    (database.delete(database.exerciseLog)
          ..where(
            (tbl) => tbl.id.equals(exerciseLogId),
          ))
        .go();
  }
}
