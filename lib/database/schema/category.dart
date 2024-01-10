import 'package:drift/drift.dart';
import 'package:pro_fit_flutter/constants/common.dart';

class Category extends Table {
  TextColumn get id => text().clientDefault(() => uuidInstance.v4())();
  TextColumn get name => text()();
  TextColumn get status => text().withDefault(const Constant('created'))();
}