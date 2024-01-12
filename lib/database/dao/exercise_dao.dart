import 'package:drift/drift.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:pro_fit_flutter/database/schema/exercise.dart';

part 'exercise_dao.g.dart';

@DriftAccessor(tables: [Exercise])
class ExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseDaoMixin {
  ExerciseDao(AppDatabase db) : super(db);


    Future<List<ExerciseData>> getAllExercisesIncludeDeleted() async {
    final query = select(exercise);
    List<ExerciseData> allExerciseItems = await query.map((row) => row).get();
    return allExerciseItems;
  }

  Future<List<ExerciseData>> getCategoryExercises(String categoryId) async {
    final query = select(exercise)
      ..where(
        (tbl) => tbl.categoryId.equals(categoryId),
      )
      ..where((tbl) => tbl.status.equals("created"));
    return query.map((row) => row).get();
  }

  void updateExerciseDetails(
    ExerciseCompanion companionData,
    String exerciseId,
  ) {
    (update(exercise)..where((t) => t.id.equals(exerciseId)))
        .write(companionData);
  }

    void insertExerciseRow(ExerciseCompanion companionData,) async {
    await into(exercise).insert(companionData);
  }

  void createExercise(String exerciseName, String categoryId) {
    into(exercise).insert(
      ExerciseCompanion.insert(
        name: exerciseName,
        categoryId: categoryId,
      ),
    );
  }

  void deleteExerciseItem(String exerciseId) {
        (update(exercise)
          ..where(
            (t) => t.id.equals(exerciseId),
          ))
        .write(
      const ExerciseCompanion(
        status: drift.Value("deleted"),
      ),
    );
  }
}
