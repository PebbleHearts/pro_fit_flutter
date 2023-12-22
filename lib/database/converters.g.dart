// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'converters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutSet _$WorkoutSetFromJson(Map<String, dynamic> json) => WorkoutSet(
      (json['weight'] as num?)?.toDouble(),
      json['repetitions'] as int?,
    );

Map<String, dynamic> _$WorkoutSetToJson(WorkoutSet instance) =>
    <String, dynamic>{
      'weight': instance.weight,
      'repetitions': instance.repetitions,
    };

WorkoutRecord _$WorkoutRecordFromJson(Map<String, dynamic> json) =>
    WorkoutRecord(
      (json['sets'] as List<dynamic>)
          .map((e) => WorkoutSet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutRecordToJson(WorkoutRecord instance) =>
    <String, dynamic>{
      'sets': instance.sets,
    };
