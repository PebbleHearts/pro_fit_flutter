import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pro_fit_flutter/data-model/common.dart';
import 'package:pro_fit_flutter/components/horizontal-date-selector/horizontal_date_selector.dart';
import 'package:pro_fit_flutter/constants/theme.dart';
import 'package:pro_fit_flutter/database/converters.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:pro_fit_flutter/screens/daily_exercise_selection_screen/daily_exercise_selection_screen.dart';
import 'package:pro_fit_flutter/screens/log_screen/log_item.dart';
import 'package:pro_fit_flutter/screens/log_screen/log_set_record_bottom_sheet.dart';
import 'package:pro_fit_flutter/screens/log_screen/routine_selection_bottom_sheet.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ExerciseLogWithExercise> _selectedDayWorkoutLog = [];
  List<RoutineData> _routines = [];
  String _selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  late ExerciseLogWithExercise _currentEditingLogItem;

  void _handleDeleteHistoryItem(String id) {
    database.exerciseLogDao.deleteExerciseLogItem(id);
    _fetchWorkoutLog();
  }

  void _showLogSetRecordBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return LogSetRecordBottomSheet(
            currentEditingLogItem: _currentEditingLogItem,
            handleSubmit: (logRecord) {
              database.exerciseLogDao.updateExerciseLog(
                ExerciseLogCompanion(
                  workoutRecords: drift.Value(
                    WorkoutRecord(logRecord),
                  ),
                ),
                _currentEditingLogItem.workoutLog.id,
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

  void _fetchWorkoutLog() async {
    List<ExerciseLogWithExercise> workoutLogItems = await database
        .exerciseLogDao
        .getDayLogWithExerciseDetails(_selectedDate);
    setState(() {
      _selectedDayWorkoutLog = workoutLogItems;
    });
  }

  void _onAddDailyWorkoutClick(ctx) async {
    await Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => DailyExerciseSelectionScreen(
          selectedDate: _selectedDate,
        ),
        fullscreenDialog: true,
      ),
    );
    _fetchWorkoutLog();
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

  Future<List<RoutineData>> _loadRoutines() async {
    List<RoutineData> allRoutineItems =
        await database.select(database.routine).get();
    return allRoutineItems;
  }

  Future<List<RoutineData>> _fetchRoutines() async {
    List<RoutineData> allRoutineItems = await _loadRoutines();
    return allRoutineItems;
  }

  Future<List<ExerciseLogData>> _getLatestLogOfSpecificExercise(
      String exerciseId) async {
    final query = database.select(database.exerciseLog)
      ..where((tbl) => tbl.exerciseId.equals(exerciseId))
      ..orderBy([
        (t) => drift.OrderingTerm(
            expression: t.logDate, mode: drift.OrderingMode.desc)
      ])
      ..limit(1);
    return query.map((row) => row).get();
  }

  void _handleRoutineExecution(String routineId) async {
    final query = database.select(database.routineDetailItem)
      ..where((tbl) => tbl.routineId.equals(routineId));
    List<RoutineDetailItemData> allRoutineItemWithId =
        await query.map((p0) => p0).get();

    for (int i = 0; i < allRoutineItemWithId.length; i++) {
      final latestSameExerciseLog = await _getLatestLogOfSpecificExercise(
          allRoutineItemWithId[i].exerciseId);
      final WorkoutRecord workoutRecords = latestSameExerciseLog.isNotEmpty
          ? latestSameExerciseLog[0].workoutRecords
          : WorkoutRecord(
              [WorkoutSet(0, 0), WorkoutSet(0, 0), WorkoutSet(0, 0)],
            );
      await database.into(database.exerciseLog).insert(
            ExerciseLogCompanion.insert(
              exerciseId: allRoutineItemWithId[i].exerciseId,
              logDate: _selectedDate,
              description: "",
              workoutRecords: workoutRecords,
              order: i,
            ),
          );
    }

    _fetchWorkoutLog();
  }

  _handleExecuteARoutineClick() async {
    final List<RoutineData> allRoutineItems = await _fetchRoutines();
    setState(() {
      _routines = allRoutineItems;
    });

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return RoutineSelectionBottomSheet(
            routines: _routines, onRoutineStart: _handleRoutineExecution);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleTheme.primary,
        foregroundColor: Colors.white,
        title: const Text('ProFit'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: purpleTheme.background,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 26, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 200,
                            child: Center(
                              child: Text(
                                'Log',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (_selectedDayWorkoutLog.isNotEmpty)
                            ..._selectedDayWorkoutLog
                                .asMap()
                                .entries
                                .map(
                                  (e) => Column(
                                    children: [
                                      LogItem(
                                        logData: e.value,
                                        onEdit: () => _handleEditHistoryItem(
                                            e.value.workoutLog.id),
                                        onDelete: () =>
                                            _handleDeleteHistoryItem(
                                                e.value.workoutLog.id),
                                      ),
                                      if (e.key <
                                          _selectedDayWorkoutLog.length - 1)
                                        const SizedBox(height: 7),
                                    ],
                                  ),
                                )
                                .toList(),
                          if (_selectedDayWorkoutLog.isEmpty)
                            TextButton(
                              onPressed: _handleExecuteARoutineClick,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.play_circle),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Execute a Routine'),
                                ],
                              ),
                            )
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
            bottom: 46.0,
            right: 5.0,
            child: FloatingActionButton.small(
              heroTag: null,
              backgroundColor: purpleTheme.primary,
              foregroundColor: Colors.white,
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