import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/DataModel/common.dart';
import 'package:pro_fit_flutter/components/bottom-sheet/bottom_sheet.dart';
import 'package:pro_fit_flutter/components/custom_elevated_button/custom_elevated_button.dart';
import 'package:pro_fit_flutter/constants/theme.dart';
import 'package:pro_fit_flutter/database/converters.dart';
import 'package:pro_fit_flutter/screens/log_screen/log_record_row.dart';

typedef HandleSubmitFunction = void Function(List<WorkoutSet>);

class LogSetRecordBottomSheet extends StatefulWidget {
  final HandleSubmitFunction handleSubmit;
  final ExerciseLogWithExercise currentEditingLogItem;
  const LogSetRecordBottomSheet({
    super.key,
    required this.handleSubmit,
    required this.currentEditingLogItem,
  });

  @override
  State<LogSetRecordBottomSheet> createState() =>
      _LogSetRecordBottomSheetState();
}

class _LogSetRecordBottomSheetState extends State<LogSetRecordBottomSheet> {
  List<WorkoutSet> _currentWorkoutRecord = [];

  void _handleSetRecordChange(int index, String fieldType, String value) {
    if (fieldType == 'weight') {
      _currentWorkoutRecord[index].weight = double.parse(value);
    } else if (fieldType == 'repetitions') {
      _currentWorkoutRecord[index].repetitions = int.parse(value);
    }
  }

  @override
  void initState() {
    super.initState();
    _currentWorkoutRecord =
        widget.currentEditingLogItem.workoutLog.workoutRecords.sets;
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      bottomSheetContent: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Edit Workout Item',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 10,
            ),
            ...widget.currentEditingLogItem.workoutLog.workoutRecords.sets
                .asMap()
                .entries
                .map((e) {
              return LogRecordRow(
                index: e.key,
                weight: e.value.weight,
                repetitions: e.value.repetitions,
                onChange: _handleSetRecordChange,
              );
            }).toList(),
            const SizedBox(height: 15),
            CustomElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                widget.handleSubmit(_currentWorkoutRecord);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
