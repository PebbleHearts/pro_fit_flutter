import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro_fit_flutter/DataModel/common.dart';
import 'package:pro_fit_flutter/components/horizontal-date-selector/horizontal_date_selector.dart';
import 'package:pro_fit_flutter/database/converters.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:pro_fit_flutter/screens/daily_exercise_selection_screen/daily_exercise_selection_screen.dart';
import 'package:pro_fit_flutter/screens/log_screen/log_item.dart';
import 'package:pro_fit_flutter/screens/log_screen/log_set_record_bottom_sheet.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ExerciseLogWithExercise> _selectedDayWorkoutLog = [];
  String _selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  late ExerciseLogWithExercise _currentEditingLogItem;

  void _handleDeleteHistoryItem(String id) {
    (database.delete(database.exerciseLog)
          ..where(
            (tbl) => tbl.id.equals(id),
          ))
        .go();
    _fetchWorkoutLog();
  }

  void _showLogSetRecordBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return LogSetRecordBottomSheet(
            currentEditingLogItem: _currentEditingLogItem,
            handleSubmit: (logRecord) {
              (database.update(database.exerciseLog)
                    ..where(
                      (t) => t.id.equals(_currentEditingLogItem.workoutLog.id),
                    ))
                  .write(
                ExerciseLogCompanion(
                  workoutRecords: drift.Value(
                    WorkoutRecord(logRecord),
                  ),
                ),
              );

              _fetchWorkoutLog();
            });
      },
    );
  }

  void _handleEditHistoryItem(String id) {
    ExerciseLogWithExercise currentEditingLogItem =
        _selectedDayWorkoutLog.firstWhere(
      (element) => element.workoutLog.id == id,
    );
    setState(() {
      _currentEditingLogItem = currentEditingLogItem;
    });
    _showLogSetRecordBottomSheet(context);
  }

  Future<List<ExerciseLogWithExercise>> _loadWorkoutLog() async {
    final query = database.select(database.exerciseLog).join([
      drift.innerJoin(database.exercise,
          database.exerciseLog.exerciseId.equalsExp(database.exercise.id)),
    ])
      ..where(
        database.exerciseLog.logDate.equals(_selectedDate),
      );
    return query.map((row) {
      return ExerciseLogWithExercise(row.readTable(database.exerciseLog),
          row.readTable(database.exercise));
    }).get();
  }

  void _fetchWorkoutLog() async {
    List<ExerciseLogWithExercise> workoutLogItems = await _loadWorkoutLog();
    setState(() {
      _selectedDayWorkoutLog = workoutLogItems;
    });
  }

  void _onAddDailyWorkoutClick(ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => DailyExerciseSelectionScreen(
          selectedDate: _selectedDate,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchWorkoutLog();
  }

  void _handleDateSelection(DateTime currentSelectedDate) {
    setState(() {
      _selectedDate = DateFormat('dd-MM-yyyy').format(currentSelectedDate);
    });
    _fetchWorkoutLog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text('ProFit'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.deepPurple.withOpacity(0.1),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 47,
                        left: 10,
                        right: 10
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 200,
                            child: Center(
                              child: Text(
                                'Log',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          ..._selectedDayWorkoutLog
                              .asMap()
                              .entries
                              .map(
                                (e) => Column(
                                  children: [
                                    HistoryItem(
                                      logData: e.value,
                                      onEdit: () => _handleEditHistoryItem(
                                          e.value.workoutLog.id),
                                      onDelete: () => _handleDeleteHistoryItem(
                                          e.value.workoutLog.id),
                                    ),
                                    if (e.key < _selectedDayWorkoutLog.length - 1)
                                      const SizedBox(height: 10),
                                  ],
                                ),
                              )
                              .toList(),
                          // ReorderableListView(
                          //   shrinkWrap: true,
                          //   children: [
                          //     ..._selectedDayWorkoutLog
                          //         .asMap()
                          //         .entries
                          //         .map(
                          //           (e) => HistoryItem(
                          //             key: ValueKey(e.value.workoutLog.id),
                          //             logData: e.value,
                          //             onEdit: () => _handleEditHistoryItem(
                          //                 e.value.workoutLog.id),
                          //             onDelete: () => _handleDeleteHistoryItem(
                          //                 e.value.workoutLog.id),
                          //           ),
                          //         )
                          //         .toList(),
                          //   ],
                          //   onReorder: (lastPosition, newPosition) {
                          //     print({lastPosition, newPosition});
                          //   },
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              HorizontalDateSelector(
                selectedDate: _selectedDate,
                onDateTap: _handleDateSelection,
              )
            ],
          ),
          Positioned(
            bottom: 47.0,
            right: 5.0,
            child: FloatingActionButton.small(
              heroTag: null,
              onPressed: () {
                _onAddDailyWorkoutClick(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
