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
  final _dummyHistoryList = [
    HistoryItemDataModel("Bench Press", [
      HistoryRecord(12.5, 15),
      HistoryRecord(12.5, 12),
      HistoryRecord(15, 8)
    ]),
    HistoryItemDataModel("Inclined Bench Press",
        [HistoryRecord(10, 15), HistoryRecord(10, 12), HistoryRecord(10, 12)]),
    HistoryItemDataModel("Pec Dec Flies",
        [HistoryRecord(35, 17), HistoryRecord(35, 15), HistoryRecord(35, 12)]),
    HistoryItemDataModel("Decline Cable Press", [
      HistoryRecord(12.5, 15),
      HistoryRecord(15, 13),
      HistoryRecord(15, 12)
    ]),
    HistoryItemDataModel("Triceps Rope Push Down", [
      HistoryRecord(10, 15),
      HistoryRecord(12.5, 13),
      HistoryRecord(12.5, 12)
    ]),
  ];

  void _handleDeleteHistoryItem(int index) {
    print("delete clicked $index");
  }

  void _handleEditHistoryItem(int index) {
    print("Edit clicked $index");
  }

  Future<List<ExerciseLogData>> _loadCategories() async {
    final database = AppDatabase();
    List<ExerciseLogData> exerciseLogItems =
        await database.select(database.exerciseLog).get();
    return exerciseLogItems;
  }

  void _fetchWorkoutLog() async {
    List<ExerciseLogData> exerciseLogItems = await _loadCategories();
    print('printing log onto screen');
    print(exerciseLogItems[0].workoutRecords.sets[1].repetitions);
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
                        ..._dummyHistoryList
                            .asMap()
                            .entries
                            .map((e) => HistoryItem(
                                  historyData: e.value,
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
              const SizedBox(height: 50, child: const HorizontalDateSelector())
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
