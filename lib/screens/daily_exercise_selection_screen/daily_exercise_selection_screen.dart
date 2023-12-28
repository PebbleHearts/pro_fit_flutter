import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/DataModel/common.dart';
import 'package:pro_fit_flutter/components/category-card/category_card.dart';
import 'package:pro_fit_flutter/constants/theme.dart';
import 'package:pro_fit_flutter/database/converters.dart';
import 'package:pro_fit_flutter/database/database.dart';
import 'package:pro_fit_flutter/screens/daily_exercise_selection_screen/daily_exercise_selection_selected_card.dart';
import 'package:pro_fit_flutter/screens/daily_exercise_selection_screen/exercise_selection_bottom_sheet.dart';

class DailyExerciseSelectionScreen extends StatefulWidget {
  final String selectedDate;
  const DailyExerciseSelectionScreen({super.key, required this.selectedDate});

  @override
  State<DailyExerciseSelectionScreen> createState() =>
      _DailyExerciseSelectionScreenState();
}

class _DailyExerciseSelectionScreenState
    extends State<DailyExerciseSelectionScreen> {
  List<CategoryData> _categories = [];
  List<ExerciseData> _selectedCategoryExercises = [];
  List<ExerciseData> _selectedExercisesForTheDay = [];
  List<ExerciseLogData> _currentDayWorkoutLogItems = [];

  Future<List<CategoryData>> _loadCategories() async {
    List<CategoryData> allCategoryItems =
        await database.select(database.category).get();
    return allCategoryItems;
  }

  void _fetchCategories() async {
    List<CategoryData> allCategoryItems = await _loadCategories();
    setState(() {
      _categories = allCategoryItems;
    });
  }

  Future<List<ExerciseData>> _fetchCategoryExercises(categoryId) async {
    final query = database.select(database.exercise)
      ..where((tbl) => tbl.categoryId.equals(categoryId));
    final categoryExerciseItems = query.map((row) => row).get();
    return categoryExerciseItems;
  }

  void _handleCategoryCardClick(id, name) async {
    final List<ExerciseData> categoryExerciseItems =
        await _fetchCategoryExercises(id);

    setState(() {
      _selectedCategoryExercises = categoryExerciseItems;
    });
    _showCustomBottomSheet(context);
  }

  void _fetchCurrentDayWorkoutLogItems() async {
    final query = database.select(database.exerciseLog)
      ..where(
        (tbl) => tbl.logDate.equals(widget.selectedDate),
      );
    final currentDayWorkoutLogItems = await query.map((row) => row).get();
    setState(() {
      _currentDayWorkoutLogItems = currentDayWorkoutLogItems;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchCurrentDayWorkoutLogItems();
  }

  void _showCustomBottomSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ExerciseSelectionBottomSheet(
          categoryExercises: _selectedCategoryExercises,
          // TODO: Shouldn't pass all the selectedExercisesFor the day. Instead we should only pass the exercises belonging to specific category
          selectedExercisesForTheDay: _selectedExercisesForTheDay,
          currentDayWorkoutLogItems: _currentDayWorkoutLogItems,
          onAddClick: (value) {
            setState(() {
              _selectedExercisesForTheDay = value;
            });
          },
        );
      },
    );
    setState(() {
      _selectedCategoryExercises = [];
    });
  }

  void _handleWorkoutLogBottomSheetSubmission() async {
    WidgetsFlutterBinding.ensureInitialized();

    for (int i = 0; i < _selectedExercisesForTheDay.length; i++) {
      await database.into(database.exerciseLog).insert(
            ExerciseLogCompanion.insert(
              exerciseId: _selectedExercisesForTheDay[i].id,
              logDate: widget.selectedDate,
              description: "",
              workoutRecords: WorkoutRecord(
                [WorkoutSet(0, 0), WorkoutSet(0, 0), WorkoutSet(0, 0)],
              ),
              order: i,
            ),
          );
    }
    Navigator.pop(context);
  }

  void _handleRemoveSelectedExercise(String itemId) {
    setState(() {
      _selectedExercisesForTheDay.removeWhere(
        (element) => element.id == itemId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: purpleTheme.background,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 47, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            'Choose Exercises',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ..._categories
                          .asMap()
                          .entries
                          .map(
                            (e) => Column(
                              children: [
                                CategoryCard(
                                  name: e.value.name,
                                  onTap: () => _handleCategoryCardClick(
                                      e.value.id, e.value.name),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          )
                          .toList(),
                      if (_selectedExercisesForTheDay.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.deepPurple.withOpacity(0.2),
                          child: Column(
                            children: [
                              const Text(
                                'Selected Exercises',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              ..._selectedExercisesForTheDay
                                  .map(
                                    (e) => Column(
                                      children: [
                                        DailyExerciseSelectionSelectedCard(
                                          name: e.name,
                                          onRemove: () =>
                                              _handleRemoveSelectedExercise(
                                                  e.id),
                                        ),
                                        const SizedBox(height: 3),
                                      ],
                                    ),
                                  )
                                  .toList()
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.deepPurple.withOpacity(0.1),
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepPurple),
                    overlayColor:
                        MaterialStatePropertyAll(Colors.deepPurpleAccent)),
                onPressed: _handleWorkoutLogBottomSheetSubmission,
                child: const Text('Add'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
