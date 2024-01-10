import 'package:drift/drift.dart';
import 'package:pro_fit_flutter/constants/common.dart';

class Exercise extends Table {
  TextColumn get id => text().clientDefault(() => uuidInstance.v4())();
  TextColumn get name => text()();
  // TODO: Add a reference constraint for the category field
  TextColumn get categoryId => text()();
  TextColumn get status => text().withDefault(const Constant('created'))();
}