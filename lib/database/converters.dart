import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart';

part 'converters.g.dart';

@JsonSerializable()
class WorkoutSet {
  double weight;
  int repetitions;

  WorkoutSet(this.weight, this.repetitions);

  factory WorkoutSet.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutSetToJson(this);
}

@JsonSerializable()
class WorkoutRecord {
  List<WorkoutSet> sets;

  WorkoutRecord(this.sets);

  factory WorkoutRecord.fromJson(Map<String, dynamic> json) =>
      _$WorkoutRecordFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutRecordToJson(this);
}

class WorkoutRecordConverter extends TypeConverter<WorkoutRecord, String> {
  const WorkoutRecordConverter();

  @override
  WorkoutRecord fromSql(String fromDb) {
    return WorkoutRecord.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(WorkoutRecord value) {
    return json.encode(value.toJson());
  }
}
