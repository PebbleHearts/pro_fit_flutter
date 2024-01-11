import 'package:drift/drift.dart';
import 'package:pro_fit_flutter/data-model/common.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:pro_fit_flutter/database/schema/exercise.dart';
import 'package:pro_fit_flutter/database/schema/routine_detail_item.dart';

part 'routine_detail_item_dao.g.dart';

@DriftAccessor(tables: [RoutineDetailItem, Exercise])
class RoutineDetailItemDao extends DatabaseAccessor<AppDatabase>
    with _$RoutineDetailItemDaoMixin {
  RoutineDetailItemDao(AppDatabase db) : super(db);

  Future<List<RoutineDetailItemWithExercise>> getRoutineDetailItems(
      String routineId) async {
    final query = select(routineDetailItem).join([
      drift.innerJoin(
          exercise, routineDetailItem.exerciseId.equalsExp(exercise.id)),
    ])
      ..where(
        routineDetailItem.routineId.equals(routineId),
      );
    return query.map((row) {
      return RoutineDetailItemWithExercise(
          row.readTable(routineDetailItem),
          row.readTable(
            exercise,
          ));
    }).get();
  }

  Future<List<RoutineDetailItemData>> getAllRoutineDetailItems() async {
    List<RoutineDetailItemData> allRoutineItems =
        await select(routineDetailItem).get();
    return allRoutineItems;
  }

  Future<void> createRoutineDetailItem(
      String routineId, String exerciseId) async {
    await database.into(database.routineDetailItem).insert(
          RoutineDetailItemCompanion.insert(
            routineId: routineId,
            exerciseId: exerciseId,
          ),
        );
  }

  void deleteRoutineDetailItem(String routineDetailItemId) {
    (database.delete(database.routineDetailItem)
          ..where(
            (tbl) => tbl.id.equals(routineDetailItemId),
          ))
        .go();
  }
}
