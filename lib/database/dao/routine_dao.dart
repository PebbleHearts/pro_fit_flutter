import 'package:drift/drift.dart';
import 'package:pro_fit_flutter/data-model/common.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:pro_fit_flutter/database/schema/routine.dart';

part 'routine_dao.g.dart';

@DriftAccessor(tables: [Routine])
class RoutineDao extends DatabaseAccessor<AppDatabase> with _$RoutineDaoMixin {
  RoutineDao(AppDatabase db) : super(db);

  Future<List<RoutineData>> getAllRoutines() async {
    List<RoutineData> allRoutineItems = await select(routine).get();
    return allRoutineItems;
  }

  void insertRoutineRow(
    RoutineCompanion companionData,
  ) async {
    await into(routine).insert(companionData);
  }

  void createRoutine(String routineName) async {
    await database
        .into(database.routine)
        .insert(RoutineCompanion.insert(name: routineName));
  }

  void updateRoutine(RoutineCompanion companion, String routineId) {
    (database.update(database.routine)
          ..where(
            (t) => t.id.equals(routineId),
          ))
        .write(
      companion,
    );
  }
}
