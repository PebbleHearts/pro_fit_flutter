import 'dart:io';

import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:pro_fit_flutter/database/converters.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:drift/drift.dart';
import 'package:pro_fit_flutter/database/schema/category.dart';
import 'package:pro_fit_flutter/database/schema/exercise.dart';
import 'package:pro_fit_flutter/database/schema/exercise_log.dart';
import 'package:pro_fit_flutter/database/schema/routine.dart';
import 'package:pro_fit_flutter/database/schema/routine_detail_item.dart';
import 'package:pro_fit_flutter/constants/common.dart';
import 'package:pro_fit_flutter/database/dao/category_dao.dart';
import 'package:pro_fit_flutter/database/dao/exercise_dao.dart';
import 'package:pro_fit_flutter/database/dao/exercise_log_dao.dart';
import 'package:pro_fit_flutter/database/dao/routine_dao.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Category,
  Exercise,
  ExerciseLog,
  Routine,
  RoutineDetailItem,
], daos: [CategoryDao, ExerciseDao, ExerciseLogDao, RoutineDao,])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    });
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
