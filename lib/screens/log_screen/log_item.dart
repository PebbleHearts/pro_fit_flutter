import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/DataModel/common.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:pro_fit_flutter/screens/log_screen/record_item.dart';

class HistoryItem extends StatelessWidget {
  final ExerciseLogWithExercise logData;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const HistoryItem({
    super.key,
    required this.logData,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(logData.exercise!.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: onEdit,
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                        )),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ...logData.workoutLog.workoutRecords.sets.asMap().entries.map(
                (e) => RecordItem(
                    index: e.key,
                    data: e.value,
                    showDivider: e.key != logData.workoutLog.workoutRecords.sets.length - 1),
              )
        ],
      ),
    );
  }
}
