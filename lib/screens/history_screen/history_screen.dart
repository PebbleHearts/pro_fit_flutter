import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/DataModel/common.dart';
import 'package:pro_fit_flutter/components/horizontal-date-selector/horizontal_date_selector.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:pro_fit_flutter/screens/daily_exercise_selection_screen/daily_exercise_selection_screen.dart';
import 'package:pro_fit_flutter/screens/history_screen/history_item.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ExerciseLogData> _selectedDayWorkoutLog = [];
  String _selectedDate = '23-12-2023';

  void _handleDeleteHistoryItem(int index) {
    print("delete clicked $index");
  }

  void _handleEditHistoryItem(int index) {
    print("Edit clicked $index");
  }

  Future<List<ExerciseLogData>> _loadCategories() async {
    final database = AppDatabase();
    final query = database.select(database.exerciseLog)
      ..where(
        // (tbl) => tbl.categoryId.equals('23-12-2023'),
        (tbl) => tbl.logDate.equals('23-12-2023'),
      );
    final exerciseLogItems = query.map((row) => row).get();
    print(exerciseLogItems);
    return exerciseLogItems;
  }

  void _fetchWorkoutLog() async {
    List<ExerciseLogData> exerciseLogItems = await _loadCategories();
    print('printing log onto screen');
    setState(() {
      _selectedDayWorkoutLog = exerciseLogItems;
    });
  }

  void _onAddDailyWorkoutClick(ctx) {
    Navigator.push(ctx, MaterialPageRoute(builder: (context) => DailyExerciseSelectionScreen()));
  }

  @override
  void initState() {
    super.initState();
    _fetchWorkoutLog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text('History'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.deepPurple.withOpacity(0.1),
                    padding: const EdgeInsets.only(bottom: 47),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                              'History',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        ..._selectedDayWorkoutLog
                            .asMap()
                            .entries
                            .map((e) => HistoryItem(
                                  logData: e.value,
                                  onEdit: () => _handleEditHistoryItem(e.key),
                                  onDelete: () =>
                                      _handleDeleteHistoryItem(e.key),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50, child: HorizontalDateSelector(selectedDate: _selectedDate))
            ],
          ),
          Positioned(
            bottom: 55.0,
            right: 5.0,
            child: FloatingActionButton.small(
              onPressed: () {
                // Add your FAB onPressed action here
                print('Floating Action Button pressed');
               _onAddDailyWorkoutClick(context);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.small(
      //   child: const Icon(Icons.add),
      //   onPressed: () {},
      // ),
    );
  }
}
