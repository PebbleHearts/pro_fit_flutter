import 'package:drift/drift.dart';
import 'package:pro_fit_flutter/constants/common.dart';

class Routine extends Table {
  TextColumn get id => text().clientDefault(() => uuidInstance.v4())();
  TextColumn get name => text()();
}