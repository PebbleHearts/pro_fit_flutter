import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:pro_fit_flutter/data-model/common.dart';
import 'package:pro_fit_flutter/components/category-card/category_card.dart';
import 'package:pro_fit_flutter/components/custom_elevated_button/custom_elevated_button.dart';
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
  String _selectedCategoryId = '';
  List<ExerciseData> _selectedCategoryExercises = [];
  List<ExerciseData> _selectedExercisesForTheDay = [];
  List<ExerciseLogData> _currentDayWorkoutLogItems = [];

  Future<List<CategoryData>> _loadCategories() async {
    final query = database.select(database.category)
      ..where((tbl) => tbl.status.equals('created'));
    List<CategoryData> allCategoryItems = await query.map((p0) => p0).get();
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
      ..where((tbl) => tbl.categoryId.equals(categoryId))..where((tbl) => tbl.status.equals('created'));
    final categoryExerciseItems = query.map((row) => row).get();
    return categoryExerciseItems;
  }

  void _handleCategoryCardClick(id, name) async {
    final List<ExerciseData> categoryExerciseItems =
        await _fetchCategoryExercises(id);

    setState(() {
      _selectedCategoryId = id;
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
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return ExerciseSelectionBottomSheet(
          categoryExercises: _selectedCategoryExercises,
          selectedExercisesForTheDay: _selectedExercisesForTheDay
              .where((element) => element.categoryId == _selectedCategoryId)
              .toList(),
          currentDayWorkoutLogItems: _currentDayWorkoutLogItems,
          onAddClick: (value) {
              print('here $value') ;
              List<ExerciseData> updatedSelectedExercisesForTheDay = [..._selectedExercisesForTheDay];
              updatedSelectedExercisesForTheDay = updatedSelectedExercisesForTheDay.where((element) => (element.categoryId != _selectedCategoryId || (element.categoryId == _selectedCategoryId && value.indexWhere((item) => item.id == element.id) != -1))).toList();
              if (value.isNotEmpty) {
                for (var newItem in value) {
                  final alreadyHasItem = updatedSelectedExercisesForTheDay.indexWhere((item) => item.id == newItem.id) != -1;
                  if (!alreadyHasItem) {
                    updatedSelectedExercisesForTheDay.add(newItem);
                  }
                }
              }
            setState(() {
              _selectedExercisesForTheDay = updatedSelectedExercisesForTheDay;
            });
          },
        );
      },
    );
    setState(() {
      _selectedCategoryExercises = [];
    });
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

  void _handleWorkoutLogSubmission() async {
    WidgetsFlutterBinding.ensureInitialized();

    for (int i = 0; i < _selectedExercisesForTheDay.length; i++) {
      final latestSameExerciseLog = await _getLatestLogOfSpecificExercise(
          _selectedExercisesForTheDay[i].id);
      final WorkoutRecord workoutRecords = latestSameExerciseLog.isNotEmpty
          ? latestSameExerciseLog[0].workoutRecords
          : WorkoutRecord(
              [WorkoutSet(0, 0), WorkoutSet(0, 0), WorkoutSet(0, 0)],
            );
      await database.into(database.exerciseLog).insert(
            ExerciseLogCompanion.insert(
              exerciseId: _selectedExercisesForTheDay[i].id,
              logDate: widget.selectedDate,
              description: "",
              workoutRecords: workoutRecords,
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
                                  displayCta: false,
                                ),
                                const SizedBox(height: 7),
                              ],
                            ),
                          )
                          .toList(),
                      if (_selectedExercisesForTheDay.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              const Text(
                                'Selected Exercises',
                                style: TextStyle(fontSize: 16),
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
            color: purpleTheme.background,
            child: SizedBox(
              height: 40,
              child: CustomElevatedButton(
                onPressed: _handleWorkoutLogSubmission,
                child: const Text('Add'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
